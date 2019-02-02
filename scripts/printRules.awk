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
}

function makeRule(target_dependencies) {
    # ****TODO write function. For now, just return argument as-is
    return "Found: " target_dependencies
}


# Search for "[#DEF :gs100obj_hello_dependencies TEXT |BODY|"
/[[][#]DEF\s:?[_[:alpha:]][_[:alnum:]]*_dependencies\sTEXT\s[|]BODY[|]/ {
    expect_target_dependencies = 1; next
}
# Next line is the one we want:
expect_target_dependencies {
    print makeRule($0) # ****TODO deal with line continuation in TACL
    expect_target_dependencies = 0
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
