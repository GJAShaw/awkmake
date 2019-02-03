#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: printRules.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source, looking for
# yadda yadda yadda more explanation please Greg
# ------------------------------------------------------------------------------

BEGIN {
    IGNORECASE = 1 # gawk feature
    print ""
    print "# --------------------------------------"
    print "# rules"
    print "# --------------------------------------"
    print ""
}

# Search for "[#DEF :label_filename_dependencies TEXT |BODY|"
/[[][#]DEF[[:space:]]+:?[_[:alpha:]][_[:alnum:]]*_dependencies[[:space:]]+\
TEXT[[:space:]]+[|]BODY[|]/ {
    target_label = gensub(/[[][#]DEF[[:space:]]+:?(.+)_dependencies.+/, \
        "\\1", $0) # gensub is a gawk feature
    target_dependencies = ""
    expect_target_dependencies = 1
    next
}

# Extract from subsequent lines till we get a "]", then derive the Make rule
expect_target_dependencies {
    if (! index($0, "]")) {
        target_dependencies = target_dependencies " " $0
    } else {
        sub(/^[[:space:]]+/, "", target_dependencies)
        match(/^[_[:alnum:]]+/, target_dependencies)
        target = substr(target_dependencies, RSTART, RLENGTH)
        print target_dependencies
        printf("\t%s%s\n", target_label, "_recipe") # ****TODO will need $(call TACL...)
        print "" # empty line between rules
        expect_target_dependencies = 0
    }
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
