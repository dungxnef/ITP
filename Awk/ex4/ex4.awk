BEGIN {
    input1 = ARGV[1]
    depth = ARGV[2]
    FS = "/"
    order = ""
    while ((getline line < input1) > 0) {
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line)
        key = ""
        split(line, parts, FS)
        for (i = 1; i <= depth && i <= length(parts); i++) {
            if (i > 1) {
                key = key "/"
            }
            key = key parts[i]
        }
        if (!(key in count)) {
            order = order key "\n"
        }
        count[key]++
    }
    close(input1)
    split(order, keysArray, "\n")
    for (i = 1; i <= length(keysArray); i++) {
        if (length(keysArray[i]) > 0) {
            print keysArray[i], count[keysArray[i]]
        }
    } 
}
