BEGIN {
    total_negative_slack = 0
    print "Path num |           StartPoint           |          EndPoint         |    Slack"
    print "------------------------------------------------------------------------------------"
}

{
    if ($1 ~ /^Path/) {
        path_num ++
    } else if ($1 ~ /^StartP/) {
        start_point = $2
        while (getline > 0 && $0 !~ /^EndP:/ && $0 !~ /^Slack:/) {
            start_point = start_point $1
        }
        if ($0 ~ /^EndP:/) {
            end_point = $2
            while (getline > 0 && $0 !~ /^Slack:/) {
                end_point = end_point $1
            }
        }
        if ($0 ~ /^Slack:/) {
            slack = $2
            total_negative_slack += slack
            line = sprintf("%-8s | %-30s | %-25s | %6.2f", path_num, start_point, end_point, slack)
            print line
        }
    }
}

END {
    print "------------------------------------------------------------------------------------"
    printf "%-69s | %6.2f\n", "Total negative slack", total_negative_slack
}