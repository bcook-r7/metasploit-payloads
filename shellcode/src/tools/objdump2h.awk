BEGIN \
{
    printf "char %s[] =\n", name
}

NR < 7 \
{
    next
}

{
    line = "    \""
    matches = 0

    for (i = 2; i <= NF; i++) {
        if (match($(i), /^[0-9a-f][0-9a-f]$/)) {
            line = line "\\x" $(i)
            matches++
        } else
            break
    }

    if (!matches)
        next

    line = line "\""
    printf "%-28s // %-6s %s\n", line, $(i), $(++i)
}

END \
{
    printf ";\n"
}
