#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: taclToMake.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source and creates a GNU Makefile
# ------------------------------------------------------------------------------

# ----
#BEGIN
# ----
BEGIN {
    IGNORECASE = 1 # gawk feature
    
    # 'delete' reserves these variable names for arrays
    delete source_array
    delete targets_array
    delete dependencies_array
    
}

# -------------
# Include library
# -------------
@include "script/library.awk" # @include is a gawk feature

# -------------
# Define functions
# -------------

# (****TODO remove section if none needed)

# -------------
# Process input
# -------------

# Ignore commented-out lines
/^[[:space:]]*==/ { next }

# Ignore empty lines
/^[[:space:]]*$/ { next }

# Look for a ?SECTION directive, get its name, assign it to section variable
/^[[:space:]]*\?SECTION[[:space:]]+([[:alpha:]][[:alnum:]_^]{0,30})/ {
    section = $2
    next
}

# Deal with section contents appropriately
// {
    switch (section) {

    case "define_sourcemap":
        build_sourcemap_array()
        break
        
    case "define_targets":
        build_targets_array()
        break

    case "define_dependencies":
        build_dependencies_array()
        break

    default:
        break
    }
}

# ---
# END
# ---
END {

    print "# ---------------------------------------------"
    print "# file: build.mk"
    print "# type: GNU Make file"
    print "# **** This file was programatically written by"
    print "# **** GAWK, from the contents of build.tacl"
    print "# ---------------------------------------------"
    print ""

    # ****TODO print build.mk


    # ****TODO Once development is over, don't print the array contents!    
    print ""
    print "sourcemap_array:"
    for (i in sourcemap_array) {
        for (j in sourcemap_array[i])
            printf("%s ", sourcemap_array[i][j])
        print ""
    }

    print ""
    print "dependencies_array:"
    for (i in dependencies_array) {
        for (j in dependencies_array[i])
            printf("%s ", dependencies_array[i][j])
        print ""
    }

    print ""
    print "targets_array:"
    for (i in targets_array) {
        for (j in targets_array[i])
            printf("%s ", targets_array[i][j])
        print ""
    }
    
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
