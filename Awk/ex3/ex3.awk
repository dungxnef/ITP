BEGIN{
    input1 = ARGV[1]
    while((getline line < input1) > 0){
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", line)
        count[line] ++
    }
    close(input1)

    for (element in count){
        print element,count[element]
    }
}