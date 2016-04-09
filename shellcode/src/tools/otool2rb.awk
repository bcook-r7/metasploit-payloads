BEGIN \
{
    indent = 12
    width = 110

    printf "%10s'Payload' =>\n", ""
    column = 0

    for (i = 0; i < indent; i++) {
        printf " "
        column++
    }

    printf "\""
    column++
}

NR < 3 \
{
    next
}

{
    for (i = 2; i <= NF; i++) {
        if (match($(i), /^[0-9a-f][0-9a-f]$/)) {
            printf "\\x" $(i)
            column += 4

            if (column + 8 > width) {
                printf "\" +\n"
                column = 0

                for (j = 0; j < indent; j++) {
                    printf " "
                    column++
                }

                printf "\""
                column++
            }
        }
    }
}

END \
{
    printf "\"\n%8s}\n%6s))\n%2send\nend\n", "", "", ""
}
