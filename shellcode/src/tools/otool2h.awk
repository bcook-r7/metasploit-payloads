BEGIN \
{
    indent = 4
    width = 76

    printf "char %s[] =\n", name
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

            if (column + 6 > width) {
                printf "\"\n"
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
    printf "\";\n"
}
