# Append phrase from PHRASE_FILE before " Horizon wording" on the Barket row.
BEGIN {
    phrase_path = ENVIRON["PHRASE_FILE"]
    while ((getline line < phrase_path) > 0) {
        p = p line
    }
    close(phrase_path)
}
/^\| \*\*Barket\*\*/ && !done {
    if (index($0, " Horizon wording") == 0) {
        print
        next
    }
    sub(/ Horizon wording/, p " Horizon wording")
    done = 1
}
{
    print
}
