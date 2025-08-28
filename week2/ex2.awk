/INVX[0-9]+_LVT/ {
    refname = $1
    sub(/\/[A-Z0-9]+$/, "", refname)  
    sub(/_LVT/, "_ULVT", refname)
    midpart = $2
    gsub(/[\(\)]/, "", midpart)  
    sub(/_LVT/, "_ULVT", midpart)  

    # Count occurrences
    count[refname]++
    
    # Print only if occurrence is less than or equal to 2
    if (count[refname] < 2) {
        print "size_cells [get_cells " refname "] " midpart > "fix.setup.tcl"
    }
}

/NBUFFX[0-9]+_LVT/ {
    refname = $1
    sub(/\/[A-Z0-9]+$/, "", refname)  # Remove everything after and including '/A', '/Y', etc.
    sub(/_LVT/, "_ULVT", refname)
    midpart = $2
    gsub(/[\(\)]/, "", midpart)  # Remove parentheses
    sub(/_LVT/, "_ULVT", midpart) 

    # Count occurrences
    count[refname]++
    
    # Print only if occurrence is less than or equal to 2
    if (count[refname] < 2) {
        print "size_cells [get_cells " refname "] " midpart > "fix.setup.tcl"
    }
}