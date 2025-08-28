#!/bin/csh -f
set input1 = $1

awk 'BEGIN { \
    while ((getline line < "'$input1'") > 0) { \
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line) \
        count[line] ++ \
    } \
    close("$input1") \
    for (element in count) { \
        print element, count[element] \
    } \
} ' $input1
