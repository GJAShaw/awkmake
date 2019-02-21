#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: map_guardian180_to_guardian101.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source and creates part of a GNU Makefile
# ------------------------------------------------------------------------------

# ----
#BEGIN
# ----
BEGIN {
    IGNORECASE = 1 # gawk feature
    print ""
    print "# ---------------------------------------------"
    print "# CTOEDIT C-format source to EDIT-format source"
    print "# ---------------------------------------------"
    print ""
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
    if (section == "map_guardian180_to_guardian101") {
        print "stub!" section
    }
}

# ---
# END
# ---
END {
    print ""
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
