#!/bin/csh -f
set input1 = $1
set depth = $2

awk 'BEGIN { \
    FS = "|" \
    OFS = "|" \
    delete ARGV[2] \
} \
{ \
    if (NR > 2 && $1 != "" && $1 !~ /^-+$/) { \
        path_num = $1 \
        start_point = $2 \
        end_point = $3 \
        slack = $4 \
        split(start_point, start_parts, "/") \
        split(end_point, end_parts, "/") \
        start_module = "" \
        end_module = "" \
        for (i = 1; i <= "'$depth'"; i++) { \
            if (i <= length(start_parts)) { \
                start_module = start_module (i > 1 ? "/" : "") start_parts[i] \
            } \
            if (i <= length(end_parts)) { \
                end_module = end_module (i > 1 ? "/" : "") end_parts[i] \
            } \
        } \
        module_pair = start_module " -> " end_module \
        if (!(module_pair in wns)) { \
            wns[module_pair] = slack \
            tns[module_pair] = 0 \
            nvp[module_pair] = 0 \
            order[++order_count] = module_pair \
        } \
        if (slack < wns[module_pair]) { \
            wns[module_pair] = slack \
        } \
        tns[module_pair] += slack \
        nvp[module_pair]++ \
    } \
} \
END { \
    print "-------------------------------------" \
    print "WNS   |TNS     |NVP  |module2module" \
    print "-------------------------------------" \
    for (i = 1; i <= order_count; i++) { \
        module_pair = order[i] \
        printf "%-5.2f |%-7.2f |%-4d |%s\n", wns[module_pair], tns[module_pair], nvp[module_pair], module_pair \
    } \
    print "----------------------------------" \
    total_wns = 99999 \
    total_tns = 0 \
    total_nvp = 0 \
    for (i = 1; i <= order_count; i++) { \
        module_pair = order[i] \
        if (wns[module_pair] < total_wns) { \
            total_wns = wns[module_pair] \
        } \
        total_tns += tns[module_pair] \
        total_nvp += nvp[module_pair] \
    } \
    printf "%-5.2f |%-7.2f |%-4d\n", total_wns, total_tns, total_nvp \
} ' $input1 $depth
