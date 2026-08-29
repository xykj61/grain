#!/bin/sh
# skate_macos_choice_control.sh -- prove the native Skate decision scan both ways.

set -eu

root=$(pwd)
scan=$root/tools/fixtures/s/skate_macos_choice_scan.sh
live=$root/external-research/20260826-145514_skate-native-macos-decision-tablecloth.md
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

mutate_and_expect_red() {
  name=$1
  from=$2
  to=$3
  sed "s|$from|$to|" "$live" > "$work/$name.md"
  code=0
  sh "$scan" "$work/$name.md" no >/dev/null 2>&1 || code=$?
  [ "$code" -ne 0 ]
}

mutate_and_expect_red reversed-choice \
  '\*\*Decision:\*\* \*\*Swift 6.2 or newer with AppKit\*\*' \
  '**Decision:** **Objective-C with AppKit**'
echo 'reversed_choice_refused=yes'

mutate_and_expect_red false-certification \
  'It is not NASA certification' \
  'It is NASA certification'
echo 'false_certification_refused=yes'

awk 'index($0, "https://spinroot.com/gerard/pdf/Power_of_Ten.pdf") == 0 { print }' "$live" > "$work/missing-source.md"
code=0
sh "$scan" "$work/missing-source.md" no >/dev/null 2>&1 || code=$?
[ "$code" -ne 0 ]
echo 'missing_primary_source_refused=yes'

mutate_and_expect_red executable-aether \
  '\*\*Aetheric remains a conceptual and poetic design register\.\*\*' \
  '**Aetheric is the aether engine.**'
echo 'executable_aether_refused=yes'

mutate_and_expect_red false-sketchbook-pin \
  '99b87f20f1fdbd2fc216cb13c07bdd0531916d27' \
  '0000000000000000000000000000000000000000'
echo 'false_sketchbook_pin_refused=yes'

sh "$scan" "$live" yes >/dev/null
echo 'living_decision_accepted=yes'
echo 'control_verdict=ok'
