BEGIN{
    input1 = ARGV[1]
    input2 = ARGV[2]
    while((getline line < input1) > 0){
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/,"",line)
        split(line, words," ")
       "elements1[words] = 1"
        for(i in words){
            elements1[words[i]] =1 
        }
    } 
    while((getline line < input2) > 0){
        sub(/^[ \t\r\n]+|[ \t\r\n]+$/,"",line)
        split(line, words," ")
        "elements2[words] = 1"
        for(i in words){
            elements2[words[i]] =1 
        }
    }
    for(element in elements1){
        if(element in elements2){
            same[element] = 1    
        }else{
            diff[element] = 1
        }      
    }  
    for(element in elements2){
        if(!(element in elements1)){
            diff[element] = 1    
        }else{
            delete diff[element]
        }      
    }
    same_count = 0
    diff_count = 0
    for(element in same){
        print element > "01_same.txt"
        same_count++
    }
    print "Number of same element: " same_count >> "01_same.txt"
     
    for(element in diff){
        print element > "01_diff.txt"
        diff_count++
    }
    print "Number of diff element: " diff_count >> "01_diff.txt"
}
