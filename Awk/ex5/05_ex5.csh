#!/bin/csh -f
set input1 = $1

awk 'BEGIN { \
    lines = 0 \
    words = 0 \
    characters = 0 \
} \
{ \
    lines++ \
    words += NF \
    characters += length($0) \
} \
END { \
    print "Lines:", lines, "Words:", words, "Characters:", characters \
} ' $input1
