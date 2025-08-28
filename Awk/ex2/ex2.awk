BEGIN {
    input1 = ARGV[1]
    input2 = ARGV[2]
    mode = ARGV[3]
    index1 = ARGV[4]
    index2 = ARGV[5]
    if (mode == "row") {
        row_count = 0
        while ((getline line < input1) > 0) {
            sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line)
            row_count++
            if (row_count == index1) {
                split(line, words, " ")
                for (i in words) {
                    elements1[words[i]] = 1
                }
                break
            }
        }
        close(input1)
        # Read the specified row from input2
        row_count = 0
        while ((getline line < input2) > 0) {
            sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line)
            row_count++
            if (row_count == index2) {
                split(line, words, " ")
                for (i in words) {
                    elements2[words[i]] = 1
                }
                break
            }
        }
        close(input2)
    } else if (mode == "column") {
        while ((getline line < input1) > 0) {
            sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line)
            split(line, words, " ")
            if (index1 <= length(words)) {
                elements1[words[index1]] = 1
            }
        }
        close(input1)
        while ((getline line < input2) > 0) {
            sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line)
            split(line, words, " ")
            if (index2 <= length(words)) {
                elements2[words[index2]] = 1
            }
        }
        close(input2)
    } else {
        print "Invalid mode. Use 'row' or 'column'."
        exit 1
    }

    for (element in elements1) {
        if (element in elements2) {
            same[element] = 1
        } else {
            diff[element] = 1
        }
    }

    for (element in elements2) {
        if (!(element in elements1)) {
            diff[element] = 1
        }
    }

    same_count = 0
    diff_count = 0

    # print "Same elements:"
    for (element in same) {
        print element > "02_same.txt"
        same_count++
    }
    print "Number of same elements: " same_count > "02_same.txt"

    # print "Different elements:"
    for (element in diff) {
        print element > "02_diff.txt"
        diff_count++
    }
    print "Number of different elements: " diff_count > "02_diff.txt"
}