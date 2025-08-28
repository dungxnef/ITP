/NBUFFX2_HVT/ {
    ref_name = $2
    gsub(/[\(\)]/, "", ref_name)  # Remove parentheses
    pin = $1

    print "insert_buffer [get_pins "pin"] " ref_name > "fix.hold.tcl"
}