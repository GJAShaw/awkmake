#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: map_source_to_guardian180.awk
# type: GAWK program
# project: awkmake
#
# This program reads a TACL libarary file and creates part of a GNU Makefile.
#
# The only lines of interest to this program in the TACL file are those within
# ?SECTION map_source_to_guardian180.
#
# Empty TACL lines and commented-out TACL lines are ignored.
#
# Within the section, the program looks for all STRUCTs of this format:
#
# [#DEF :gstalsrc STRUCT == colon isn't mandatory, but is good practice
#   BEGIN
#     SUBVOL sv180 VALUE $STAT.GS180TAL; == sv180 name is mandatory
#   END;
# ]
#
# For each STRUCT, this program writes a GNU Make pattern rule, e.g.
#
# /G/stat/gs180tal/%: src/gstalsrc/%
#	@echo 'Copying $< to $@...'
#	@cp -Wclobber $< $@ 
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
    if (section == "map_source_to_guardian180")
       get_source_info()
}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
