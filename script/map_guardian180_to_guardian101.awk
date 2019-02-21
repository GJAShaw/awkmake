#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: map_guardian180_to_guardian101.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source and creates part of a GNU Makefile
# ------------------------------------------------------------------------------

BEGIN {
    IGNORECASE = 1 # gawk feature
}


# -------------
# Define functions
# -------------

# (none yet)

# -------------
# Process input
# -------------

# Ignore commented-out lines
/^[[:space:]]*==/ { next }

# Ignore empty lines
/^[[:space:]]*$/ { next }

# Look for a ?SECTION directive, get its name
/^[[:space:]]*\?SECTION[[:space:]]+([[:alpha:]][[:alnum:]_^]{0,30})/ {
    section = $2
    next
}

# Deal with section contents appropriately
/^.*$/ {
    switch (section) {
        case "map_source_to_guardian180":
            print section
            break
        case "map_guardian180_to_guardian101":
            print section
            break
        case "define_targets":
            print section
            break
        case "define_[[:alpha:]][[:alnum:]_]*_rule":
            print section
            break
        default:
            break
    }
}



# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
