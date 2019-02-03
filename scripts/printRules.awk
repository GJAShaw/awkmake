#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: printRules.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source, looking for definitions of TEXT variables
# called ..._dependencies, then read the contents and creates a GNU Make rule
# from them. For example, TACL
#   [#DEF :gs100exe_hello_dependencies TEXT |BODY|
#     $(x_target): $(y_dependency) $(z_dependency)
#   ]
# is printed as GNU Make rule
#   $(x_target): $(y_dependency) $(z_dependency)
#   	x_target_recipe
#
# The TACL file must define x_target_recipe
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
