# tools/fixtures/data_dignity_truth.awk — an independent measurement of a succession fixture.
#
# DAHL-J12r4's witness cross-checks what data_dignity_true reports against this awk's reading of the same
# real bytes — two tools, one answer — so a succession's outcome can never drift from a record a keeper can
# open and count by hand. It reads each `hold <item> <disposition>` line and counts the will's marks:
# disposition 0 is bequeathed (passes to the heir), disposition 1 is rested (extinguished at succession,
# inherited by no one). The heir-held count encodes the succession rule structurally — after succession the
# heir holds exactly the bequeathed set — so heir_held equals the bequeathed count. The app computes the
# same heir-held figure by *actually running* the signed succession and resolving each item's holder, so
# the two figures agreeing proves the succession machinery yields exactly the marks awk reads.
#
#   awk -f tools/fixtures/data_dignity_truth.awk surf/fixtures/estate.bron
#   -> "<bequeathed> <rested> <heir_held>"

/^hold / {
    disp = $3 + 0
    if (disp == 0) bequeathed += 1
    else if (disp == 1) rested += 1
}
END {
    heir_held = bequeathed + 0 # after succession the heir holds exactly the bequeathed set
    print bequeathed + 0, rested + 0, heir_held
}
