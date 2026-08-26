#!/bin/sh
# arbor/author.sh -- render and check metadata-free Arbor voice tiles from Brix.

set -eu
LC_ALL=C
export LC_ALL

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
    printf 'arbor: %s\n' "$*" >&2
    exit 1
}

read_u32_const() {
    file=$1
    name=$2
    value=$(awk -v wanted="$name:" '$1 == "pub" && $2 == "const" && $3 == wanted { gsub(/;/, "", $6); print $6; exit }' "$repo_root/$file")
    case "$value" in
        ''|*[!0-9]*) fail "cannot read $name from $file" ;;
    esac
    printf '%s\n' "$value"
}

max_doc_bytes=$(read_u32_const scribble/scribble_core.rye max_doc_bytes)
max_tiles=$(read_u32_const lattice/lattice_core.rye max_dim)
max_tile_bytes=$(read_u32_const lantern/lantern_core.rye max_prompt_len)

grep -q '^[[:space:]]*other,' "$repo_root/ember/ember_core.rye" || fail 'Ember no longer exposes kind other'
grep -q 'path_suffix' "$repo_root/ember/ember_core.rye" || fail 'Ember no longer exposes the path-suffix seam'

safe_relative_path() {
    path=$1
    case "$path" in
        ''|/*|../*|*/../*|*/..|*'//'*) fail "unsafe repository path: $path" ;;
    esac
}

check_arbor_file() {
    file=$1
    label=$2
    case "$label" in
        *.arbor) ;;
        *) fail "readable output must use the .arbor extension: $label" ;;
    esac
    test -f "$file" || fail "missing readable tile: $label"
    bytes=$(wc -c < "$file" | tr -d ' ')
    test "$bytes" -gt 0 || fail "readable tile is empty: $label"
    test "$bytes" -le "$max_doc_bytes" || fail "$label exceeds Scribble's $max_doc_bytes-byte document bound"

    awk -v max_tiles="$max_tiles" -v max_tile_bytes="$max_tile_bytes" '
        function refuse(reason) {
            printf "arbor: %s at line %d\n", reason, NR > "/dev/stderr"
            bad = 1
        }
        BEGIN { tiles = 0; previous_blank = 1 }
        /\r/ { refuse("carriage return is outside the plain voice form") }
        /^[[:space:]]*$/ {
            if (previous_blank) refuse("tiles need exactly one blank breath between them")
            previous_blank = 1
            next
        }
        {
            if (!previous_blank) refuse("each tile must occupy one physical line")
            previous_blank = 0
            tiles++
            line = $0
            if (length(line) > max_tile_bytes) refuse("tile exceeds Lantern prompt bound")
            if (line != trim(line)) refuse("tile has leading or trailing whitespace")
            if (line !~ /^[A-Z]/) refuse("tile must open as a spoken sentence")
            if (line !~ /[.!?]$/) refuse("tile must close as a complete spoken thought")
            if (line ~ /[0-9]/) refuse("write numbers as words for voice")
            if (line ~ /^(---|#|```|~~~|[-*+] |[0-9]+[.)] )/) refuse("structural markup is not readable prose")
            if (line ~ /[`*_\[\]{}<>\\]/) refuse("markup or stage syntax is not readable prose")
            if (line ~ /:\/\// || line ~ /\.\//) refuse("links and paths belong in sidecars")
            if (line ~ /\$\(|&&|\|\||(^|[[:space:]])--[[:alnum:]]/) refuse("operational syntax belongs outside Arbor")
            low = tolower(line)
            if (low ~ /^(format|title|name|voice|style|status|stamp|version|kind|output|catalog|tile|language|prompt|model|role)(:|[[:space:]])/) refuse("metadata belongs in a sidecar")
        }
        END {
            if (previous_blank && NR > 0) refuse("file must end on the final spoken tile")
            if (tiles == 0) refuse("file has no spoken tiles")
            if (tiles > max_tiles) refuse("tile count exceeds Lattice shape")
            if (bad) exit 1
        }
        function trim(s) {
            sub(/^[[:space:]]+/, "", s)
            sub(/[[:space:]]+$/, "", s)
            return s
        }
    ' "$file"
}

check_arbor() {
    rel=$1
    safe_relative_path "$rel"
    check_arbor_file "$repo_root/$rel" "$rel"
}

parse_descriptor() {
    descriptor=$1
    rendered=$2
    meta=$3
    : > "$rendered"
    : > "$meta"
    awk -v rendered="$rendered" -v meta="$meta" -v max_tiles="$max_tiles" -v max_tile_bytes="$max_tile_bytes" '
        function refuse(reason) {
            printf "arbor: descriptor %s at line %d\n", reason, NR > "/dev/stderr"
            bad = 1
        }
        /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
        {
            split_at = index($0, " ")
            if (split_at == 0) { refuse("needs one key and one value"); next }
            key = substr($0, 1, split_at - 1)
            value = substr($0, split_at + 1)
            if (value == "") { refuse("has an empty value"); next }
            if (key == "format") {
                if (seen_format++) refuse("repeats format")
                if (value != "arbor-author-v1") refuse("has an unknown format")
            } else if (key == "output") {
                if (seen_output++) refuse("repeats output")
                output = value
            } else if (key == "catalog") {
                if (seen_catalog++) refuse("repeats catalog")
                catalog = value
            } else if (key == "tile") {
                tiles++
                if (tiles > max_tiles) refuse("exceeds the Lattice tile shape")
                if (length(value) > max_tile_bytes) refuse("has a tile beyond the Lantern prompt bound")
                if (tiles > 1) print "" >> rendered
                print value >> rendered
            } else {
                refuse("has an unknown key")
            }
        }
        END {
            if (!seen_format) refuse("is missing format")
            if (!seen_output) refuse("is missing output")
            if (!seen_catalog) refuse("is missing catalog")
            if (tiles == 0) refuse("has no tiles")
            if (bad) exit 1
            print "output " output > meta
            print "catalog " catalog >> meta
            print "tiles " tiles >> meta
        }
    ' "$descriptor"
}

make_catalog() {
    output=$1
    lines=$2
    target=$3
    {
        printf '# Ember-compatible catalog entry. Metadata stays outside the readable Arbor value.\n'
        printf 'chunk\n'
        printf 'path %s\n' "$output"
        printf 'kind other\n'
        printf 'lines %s\n' "$lines"
    } > "$target"
}

prepare_descriptor() {
    rel=$1
    safe_relative_path "$rel"
    case "$rel" in
        *.brix) ;;
        *) fail "authoring source must use the .brix extension: $rel" ;;
    esac
    descriptor="$repo_root/$rel"
    test -f "$descriptor" || fail "missing authoring descriptor: $rel"
    descriptor_bytes=$(wc -c < "$descriptor" | tr -d ' ')
    test "$descriptor_bytes" -le "$max_doc_bytes" || fail "$rel exceeds the bounded descriptor size"
    parse_descriptor "$descriptor" "$rendered_file" "$meta_file"
    output=$(awk '$1 == "output" { print $2 }' "$meta_file")
    catalog=$(awk '$1 == "catalog" { print $2 }' "$meta_file")
    safe_relative_path "$output"
    safe_relative_path "$catalog"
    case "$output" in arbor/*.arbor) ;; *) fail 'descriptor output must stay under arbor/ and end in .arbor' ;; esac
    case "$catalog" in arbor/*.bron) ;; *) fail 'descriptor catalog must stay under arbor/ and end in .bron' ;; esac
    check_arbor_file "$rendered_file" "$output"
    line_count=$(wc -l < "$rendered_file" | tr -d ' ')
    make_catalog "$output" "$line_count" "$catalog_file"
}

usage() {
    printf '%s\n' 'usage: sh arbor/author.sh check FILE.arbor' >&2
    printf '%s\n' '       sh arbor/author.sh verify FILE.brix' >&2
    printf '%s\n' '       sh arbor/author.sh build FILE.brix' >&2
    printf '%s\n' '       sh arbor/author.sh render FILE.brix' >&2
    exit 2
}

test "$#" -eq 2 || usage
command=$1
subject=$2

case "$command" in
    check)
        check_arbor "$subject"
        printf 'arbor: GREEN readable=%s\n' "$subject"
        ;;
    verify|build|render)
        temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/grain-arbor.XXXXXX")
        rendered_file="$temp_dir/rendered.arbor"
        meta_file="$temp_dir/meta.txt"
        catalog_file="$temp_dir/catalog.bron"
        trap 'rm -f "$rendered_file" "$meta_file" "$catalog_file"; rmdir "$temp_dir"' EXIT HUP INT TERM
        prepare_descriptor "$subject"
        case "$command" in
            verify)
                test -f "$repo_root/$output" || fail "missing declared output: $output"
                test -f "$repo_root/$catalog" || fail "missing declared catalog: $catalog"
                cmp -s "$rendered_file" "$repo_root/$output" || fail "$output differs from its Brix tiles"
                cmp -s "$catalog_file" "$repo_root/$catalog" || fail "$catalog differs from the Ember-compatible reading"
                check_arbor "$output"
                printf 'arbor: GREEN descriptor=%s output=%s tiles=%s\n' "$subject" "$output" "$(awk '$1 == "tiles" { print $2 }' "$meta_file")"
                ;;
            build)
                test -d "$repo_root/$(dirname -- "$output")" || fail "output directory is missing: $output"
                test -d "$repo_root/$(dirname -- "$catalog")" || fail "catalog directory is missing: $catalog"
                cp "$rendered_file" "$repo_root/$output"
                cp "$catalog_file" "$repo_root/$catalog"
                printf 'arbor: BUILT output=%s catalog=%s\n' "$output" "$catalog"
                ;;
            render)
                command cat "$rendered_file"
                ;;
        esac
        ;;
    *) usage ;;
esac
