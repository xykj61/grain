# Prepend rows from the first file before the first living index bullet.
NR == FNR {
    buf = buf $0 ORS
    next
}
!done && /^- `20[0-9]{6}\./ {
    printf "%s", buf
    done = 1
}
{
    print
}
