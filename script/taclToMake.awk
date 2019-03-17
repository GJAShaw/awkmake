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

    case "define_source":
        build_source_array()
        break
        
    case "define_targets":
        # build_targets_array()
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

    # print rules
#    for (i in targets_array) {
#    
#        # ****TODO remove whitespace from the target_dependency_text
#        tgt_deps = dependencies_array[targets_array[i]["target_dependency_taclvar"]]["target_dependency_text"]
#        gsub(/^[[:space:]]*$/, "", tgt_deps) # remove empty lines - DOESN'T WORK
#        gsub(/^[[:space:]]*/, "", tgt_deps) # remove leading whitespace - ONLY CATCHES FIRST LINE
#        print tgt_deps
#        print "\t@echo 'Building $@, logging to $" targets_array[i]["target_log"] "...'"
#        print "\t@$(call TACL," targets_array[i]["target_recipe_taclvar"] ")"
#        print "\n"
#
#    }

    # ****TODO Once development is over, don't print the array contents!    
    print ""
    print "source_array:"
    for (i in source_array) {
        for (j in source_array[i])
            printf("%s ", source_array[i][j])
        print ""
    }

    print ""
    print "dependencies_array:"
    for (i in dependencies_array) {
        for (j in dependencies_array[i])
            printf("%s ", dependencies_array[i][j])
        print ""
    }
    
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
