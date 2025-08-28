#!/bin/csh -f
set input1 = $1

awk 'BEGIN { \
    total_negative_slack = 0 \
    path_num = 0 \
    reg2cgate_tns = 0 \
    reg2reg_tns = 0 \
    reg2cgate_nvp = 0 \
    reg2reg_nvp = 0 \
    wns = 0 \
    reg2cgate_wns = 0 \
    reg2reg_wns = 0 \
} \
{ \
    if ($1 ~ /^Path/) { \
        path_num ++ \
    } else if ($1 ~ /^StartP/) { \
        start_point = $2 \
        while (getline > 0 && $0 !~ /^EndP:/ && $0 !~ /^Group:/ && $0 !~ /^Slack:/) { \
            start_point = start_point $1 \
        } \
        if ($0 ~ /^EndP:/) { \
            end_point = $2 \
            while (getline > 0 && $0 !~ /^Group/ && $0 !~ /^Slack:/) { \
                end_point = end_point $1 \
            } \
        } \
        if ($0 ~ /^Group/) { \
            group = $2 \
            while (getline > 0 && $0 !~ /^Slack:/) { \
                group = group \
            } \
        } \
        if ($0 ~ /^Slack:/) { \
            slack = $2 \
            total_negative_slack += slack \
            if (slack < wns) { \
                wns = slack \
            } \
            if (group == "reg2cgate") { \
                reg2cgate_tns += slack \
                reg2cgate_nvp++ \
                if (slack < reg2cgate_wns) { \
                    reg2cgate_wns = slack \
                } \
            } else if (group == "reg2reg") { \
                reg2reg_tns += slack \
                reg2reg_nvp++ \
                if (slack < reg2reg_wns) { \
                    reg2reg_wns = slack \
                } \
            } \
            line_d = sprintf("%-2s |%-9s| %-29s | %-25s | %6.2f", path_num, group, start_point, end_point, slack) \
            detail[path_num] = line_d \
        } \
    } \
} \
END { \
    print "*** Summary report\n" \
    print "     |  Totals  |  reg2reg  |  reg2cgate  |" \
    print "===========================================" \
    printf "WNS  | %7.2f  | %7.2f    | %7.2f    |\n", wns, reg2reg_wns, reg2cgate_wns \
    printf "TNS  | %7.2f  | %7.2f    | %7.2f    |\n", total_negative_slack, reg2reg_tns, reg2cgate_tns \
    printf "NVP  | %5d    | %5d      | %5d      |\n", path_num, reg2reg_nvp, reg2cgate_nvp \
    print "===========================================" \
    print "\n*** Detail paths:\n" \
    print "No |  Group  |          StartPoint           |          EndPoint         |    Slack" \
    print "------------------------------------------------------------------------------------" \
    for (i = 1; i <= path_num; i++) { \
        print detail[i] \
    } \
    print "------------------------------------------------------------------------------------" \
    printf "%-72s | %6.2f\n", "Total negative slack", total_negative_slack \
} ' $input1
