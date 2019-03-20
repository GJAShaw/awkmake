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

    print "# ------------------------------------------------------------------"
    print "# file: build.mk"
    print "# type: GNU Make file"
    print "# **** This file was written by GAWK, reading the contents of"
    print "# **** build.tacl"
    print "# ------------------------------------------------------------------"
    print "\n"
    
    print "# ------------------------------------------------------------------"
    print "# variables"
    print "# ------------------------------------------------------------------"
    print ""
    
    print "# --------------------------------"
    print "# command aliases"
    print "# --------------------------------"
    print "RM := rm -Rf"
    print ""

    print "# --------------------------------"
    print "# source and dependency files"
    print "# --------------------------------"
    for (row in dependencies_array) {
        dep_name = dependencies_array[row]["name"]
        printf("%s %s %s\n", dep_name,\
            ":=", oss_fname_of(dependencies_array[row]["file"])\
        )
    }
    print ""
    
    print "# --------------------------------"
    print "# targets - intermediate and final"
    print "# --------------------------------"
    for (row in targets_array) {
        tgt_name = targets_array[row]["name"]
        printf("%s %s %s\n", tgt_name,\
            ":=", oss_fname_of(targets_array[row]["file"])\
        )
        clean_array[tgt_name] = tgt_name
        
        sec_name = targets_array[row]["name"] "_secure"
        printf("%s %s %s\n", sec_name,\
            ":=", oss_fname_of(targets_array[row]["secure"])\
        )
        # Don't add the secure name to clean_array!
    }
    print ""
    print "# --------------------------------"    
    print "# files deleted by 'clean' rule"
    print "# --------------------------------"
    print "clean_list :="
    print "clean_list += \\"
    for (row in clean_array) {
        printf("%s%s%s", "  $(", clean_array[row], ")")
        if (length(clean_array) > 1) {
            printf("%s", " \\")
        }
        print ""
        delete clean_array[row]
    }
    print ""
    
    print "# ------------------------------------------------------------------"
    print "# rules"
    print "# ------------------------------------------------------------------"
    print ""

    print "# --------------------------------"
    print "# clean"
    print "# --------------------------------"
    print ".PHONY: clean"
    print "clean:"
    print "\t-@$(RM) $(clean_list)"
    print ""


    print "# ------------------------------------------------------------------"
    print "# EOF"
    print "# ------------------------------------------------------------------"
    
#    print "# subvolume for code 180 intermediate source files"
#    for (dir in sourcemap_array) {
#        print name " := " oss_fname_of(dependencies_array[name])
#    }
    
    
    
    # ****TODO Once development is over, don't print the array contents!    
#    print ""
#    print "sourcemap_array:"
#    for (i in sourcemap_array) {
#        for (j in sourcemap_array[i])
#            printf("%s ", sourcemap_array[i][j])
#        print ""
#    }

#    print ""
#    print "dependencies_array:"
#    for (i in dependencies_array) {
#        for (j in dependencies_array[i])
#            printf("%s ", dependencies_array[i][j])
#        print ""
#    }

#    print ""
#    print "targets_array:"
#    for (i in targets_array) {
#        for (j in targets_array[i])
#            printf("%s ", targets_array[i][j])
#        print ""
#    }
    
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
