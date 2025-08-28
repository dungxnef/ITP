#!/bin/csh -f
set input1 = $1
set input2 = $2
set mode = $3

awk 'BEGIN { \
    while ((getline line < "'$input1'") > 0) { \
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line) \
        split(line,words," ") \
        for(i in words){ \
            elements1[words[i]] = 1 \
        } \
    } \
    while ((getline line < "'$input2'") > 0) { \
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line) \
        split(line,words," ") \
        for(i in words){ \
            elements2[words[i]] = 1 \
        } \
    } \
    for (element in elements1) { \
        if (element in elements2) { \
            same[element] = 1 \
        } else { \
            diff[element] = 1 \
        } \
    } \
    for (element in elements2) { \
        if (!(element in elements1)) { \
            diff[element] = 1 \
        } else { \
            delete diff[element] \
        } \
    } \
    same_count = 0 \
    diff_count = 0 \
    for (element in same) { \
        print element > "01_same.txt" \
        same_count++ \
    } \
    print "Number of same elements: " same_count >> "01_same.txt" \
    for (element in diff) { \
        print element > "01_diff.txt" \
        diff_count++ \
    } \
    print "Number of different elements: " diff_count >> "01_diff.txt" \
} ' $input1 $input2
