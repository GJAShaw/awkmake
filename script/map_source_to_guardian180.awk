#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: map_source_to_guardian180.awk
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
    print "# Copy repository source to Guardian subvolumes"
    print "# ---------------------------------------------"
    print ""
}

# -------------
# Include library
# -------------
@include "script/library.awk" # @include is a gawk feature

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
// {
    if (section == "map_source_to_guardian180") {
   
        # Look for a "[#DEF :dir STRUCT" line...
        if (match($0, /#DEF[[:space:]]+:?[[:alpha:]][[:alnum:]]{0,7}[[:space:]]\
+STRUCT/) > 0) { # regex must continue in first column
            def_dir_struct = substr($0, RSTART, RLENGTH)
            delete def_dir_struct_array
            split(def_dir_struct, def_dir_struct_array)
            colon_dir = def_dir_struct_array[2]
            match(colon_dir, /[^:]+/) # find what isn't a colon
            dir = substr(colon_dir, RSTART, RLENGTH)
        }

        # Look for a "SUBVOL sv180 VALUE $VOL.SVOL;" line...
        if (match($0, /SUBVOL[[:space:]]+sv180[[:space:]]+VALUE/) > 0) {
            subvol_semicolon = $4
            match(subvol_semicolon, /[^;]+/) # find what isn't a colon
            subvol = substr(subvol_semicolon, RSTART, RLENGTH)
            subvol_oss = oss_subvol_of(subvol)
            
            # print the Make rule:
            print ""
            print subvol_oss "/%: src/" dir "/%"
            print "\t@echo 'Copying $< to $@...'"
            print "\t@cp -Wclobber $< $@"
            print ""
        }

    }
}

# ---
# END
# ---
END {
    print ""
}

#[#DEF :gstalsrc STRUCT
#  BEGIN
#    SUBVOL sv180 VALUE $STAT.GS180TAL;
#  END;
#]


# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
