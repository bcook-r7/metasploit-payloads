BEGIN \
{
    printf "%10s'Payload' =>\n", ""
    matches = 0
}

NR < 7 \
{
    next
}

{
    if (matches)
        printf "%s", line

    matches = 0

    for (i = 2; i <= NF; i++) {
        if (match($(i), /^[0-9a-f][0-9a-f]$/)) {
            if (!matches)
                line = ""
            line = line "\\x" $(i)
            matches++
        } else
            break
    }

    if (!matches)
        next

    line = sprintf("%12s\"%s\"", "", line)
    line = sprintf("%-36s +# %-6s %s\n", line, $(i), $(++i))
}

END \
{
    sub(/\+/, " ", line)
    printf "%s", line
    printf "%8s}\n%6s))\n%2send\nend\n", "", "", ""
}
