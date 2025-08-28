BEGIN {
    # Print the header
    print "Startpoint      Endpoint        Scenario    Path Group Slack" > "bai.txt"
    count = 0
}

/^ *Startpoint:/ {
    startpoint = $2
}

/^ *Endpoint:/ {
    endpoint = $2
}

/^ *Scenario:/ {
    scenario = $2
}

/^ *Path Group:/ {
    path_group = $3
}

/^ *slack/ {
    slack = $3
    if (slack < -0.01) {
        count++
    }
    # Print the extracted information to bai.txt
    print startpoint, endpoint, scenario, path_group, slack >> "bai.txt"
}

END {
    print "Number of paths with setup violation greater than 10ps: (slack < -0.01)", count
}