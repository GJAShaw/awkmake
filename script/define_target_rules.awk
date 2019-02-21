#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: define_target_rules.awk
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
    print "# Specific target rules"
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
    switch (section) {
        case "define_targets":
            print "stub!" section
            break
        case "define_[[:alpha:]][[:alnum:]_]*_rule":
            print "stub!" section
            break
        default:
            break
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
