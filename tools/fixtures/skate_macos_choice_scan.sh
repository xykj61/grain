#!/bin/sh
# skate_macos_choice_scan.sh -- hold the native Skate decision to its evidence and boundaries.

set -u

doc=${1:-external-research/20260826-145514_skate-native-macos-decision-tablecloth.md}
check_index=${2:-yes}
index=external-research/README.md
sketch_note=gratitude/grain-sketchbook.md
swift_note=gratitude/Swift.md
submodule=gratitude/grain-sketchbook
pin=99b87f20f1fdbd2fc216cb13c07bdd0531916d27
fail=0
required=0

need() {
  required=$((required + 1))
  if ! grep -Fq "$1" "$doc"; then
    echo "missing: $1"
    fail=$((fail + 1))
  fi
}

refuse() {
  if grep -Fqi "$1" "$doc"; then
    echo "overclaim: $1"
    fail=$((fail + 1))
  fi
}

if [ ! -f "$doc" ]; then
  echo "document_missing=$doc"
  echo "verdict=missing"
  exit 1
fi

need '**Decision:** **Swift 6.2 or newer with AppKit**'
need '**Confidence:** high for Swift plus AppKit as the shell and medium for the exact shape of the'
need 'Power-of-Ten-inspired constrained profile'
need 'It is not NASA certification'
need 'A Cocoa application cannot truthfully promise that its whole process performs no dynamic'
need '## The Civic Tame constrained profile'
need '## Concrete owned structures'
need '## Phased implementation and proof'
need '## Revisit and exit triggers'
need 'The `vendor/microkit` gitlink is not populated in this worktree.'
need '**Toroidal behavior** stays exact.'
need '**Aetheric remains a conceptual and poetic design register.**'
need 'https://spinroot.com/gerard/pdf/Power_of_Ten.pdf'
need 'https://www.swift.org/blog/swift-6.2-released/'
need 'https://developer.apple.com/documentation/technologyoverviews/uikit-appkit'
need 'https://developer.apple.com/documentation/swift/imported-c-and-objective-c-apis'
need 'https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety/'
need '`99b87f20f1fdbd2fc216cb13c07bdd0531916d27`'
need 'No sketchbook source line is copied'
need '### Phase six -- signed distribution'
need 'https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html?language=objc'
need 'https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocObjectsClasses.html'
need 'https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases'
need 'https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution'
need '../gratitude/Swift.md'

refuse 'NASA-certified'
refuse 'JPL-certified'
refuse 'Power of Ten compliant'
refuse 'aetheric runtime'
refuse 'aether engine'
refuse 'Apple-certified'

non_ascii=$(LC_ALL=C tr -d '\11\12\15\40-\176' < "$doc" | wc -c | tr -d ' ')
if [ "$non_ascii" -ne 0 ]; then
  echo "non_ascii_bytes=$non_ascii"
  fail=$((fail + 1))
fi

index_rows=skipped
gitlink_pin=skipped
gitlink_entries=skipped
sketchbook_receipt=skipped
swift_gratitude=skipped
if [ "$check_index" = yes ]; then
  base=$(basename "$doc")
  index_rows=$(grep -Fc "]($base)" "$index" || true)
  if [ "$index_rows" -ne 1 ]; then
    echo "index_rows_expected_1=$index_rows"
    fail=$((fail + 1))
  fi

  gitlink_record=$(git ls-files -s -- "$submodule")
  gitlink_pin=$(printf '%s\n' "$gitlink_record" | awk '{print $2}')
  gitlink_mode=$(printf '%s\n' "$gitlink_record" | awk '{print $1}')
  gitlink_entries=$(git ls-files -s -- "$submodule" "$submodule/**" | wc -l | tr -d ' ')
  if [ "$gitlink_mode" != 160000 ] || [ "$gitlink_pin" != "$pin" ] || [ "$gitlink_entries" -ne 1 ]; then
    echo "gitlink_expected=160000:$pin entries=1"
    fail=$((fail + 1))
  fi
  if ! git config -f .gitmodules --get-regexp '^submodule\.gratitude/grain-sketchbook\.(path|url)$' |
    grep -Fq 'https://github.com/xwb122m/grain-sketchbook'; then
    echo 'submodule_url_or_path_missing=yes'
    fail=$((fail + 1))
  fi

  sketchbook_receipt=yes
  for phrase in "$pin" 'no repository-wide `LICENSE`' 'No source line is copied' 'case-insensitive macOS'; do
    if ! grep -Fq "$phrase" "$sketch_note"; then
      echo "sketchbook_receipt_missing=$phrase"
      sketchbook_receipt=no
      fail=$((fail + 1))
    fi
  done

  swift_gratitude=yes
  for phrase in 'Swift does not erase Objective-C.' 'There is no endorsement claimed here' 'https://www.swift.org/blog/swift-6.2-released/' 'https://developer.apple.com/documentation/appkit'; do
    if ! grep -Fq "$phrase" "$swift_note"; then
      echo "swift_gratitude_missing=$phrase"
      swift_gratitude=no
      fail=$((fail + 1))
    fi
  done
  swift_rows=$(grep -Fc '**`Swift.md`**' gratitude/README.md || true)
  sketch_rows=$(grep -Fc '**`grain-sketchbook.md`** + **`grain-sketchbook/`**' gratitude/README.md || true)
  if [ "$swift_rows" -ne 1 ] || [ "$sketch_rows" -ne 1 ]; then
    echo "gratitude_index_rows_swift_sketchbook=$swift_rows:$sketch_rows"
    fail=$((fail + 1))
  fi
fi

echo "required_claims=$required"
echo "missing_or_overclaimed=$fail"
echo "non_ascii_bytes=$non_ascii"
echo "index_rows=$index_rows"
echo "gitlink_pin=$gitlink_pin"
echo "gitlink_entries=$gitlink_entries"
echo "sketchbook_receipt=$sketchbook_receipt"
echo "swift_gratitude=$swift_gratitude"

if [ "$fail" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=decision_drift"
exit 1
