#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: map_guardian180_to_guardian101.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source and creates part of a GNU Makefile
#
# The only lines of interest to this program in the TACL file are those within
# ?SECTION map_guardian180_to_guardian101.
#
# Empty TACL lines and commented-out TACL lines are ignored.
#
# Within the section, the program looks for all STRUCTs of this format:
#
# [#DEF :gstalmap STRUCT == colon isn't mandatory, but is good practice
#   BEGIN
#     SUBVOL sv180 VALUE $STAT.GS180TAL; == sv180 name is mandatory
#     SUBVOL sv101 VALUE $STAT.GSTALSRC; == sv101 name is mandatory
#   END;
# ]
#
# For each STRUCT, this program writes a GNU Make pattern rule, e.g.
#
# /G/stat/gstalsrc/%: /G/stat/gs180tal/%
# 	@echo 'CTOEDIT $<, $@...'
# 	@$(call TACL,$(CTOEDIT $<, $@))
#
# NB the STRUCT name (in this case :gstalmap) isn't actually read by the GAWK
# program, so technically you could make it any valid TACL variable name you
# liked. However, it seems sensible to call it something meaningful.
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
    if (section == "map_guardian180_to_guardian101") {
        
        # Look for #DEF, signalling start of a new subvolume mapping
        if (index($0, "#DEF ") > 0) {
            got_sv180 = 0
            got_sv101 = 0
        }
        
        # Look for a "SUBVOL sv1xx VALUE $VOL.SVOL;" line...
        if (match($0, \
                /SUBVOL[[:space:]]+sv1[[:digit:]]{2}[[:space:]]+VALUE/) > 0 \
            ) {
            sv_file_code = $2
            subvol_1xx = gensub(/;/, "", "g", $4)
            subvol_1xx_oss = oss_subvol_of(subvol_1xx)

            switch (sv_file_code) {
                case "sv180":
                    subvol_180_oss = subvol_1xx_oss
                    got_sv180 = 1
                    break
                case "sv101":
                    subvol_101_oss = subvol_1xx_oss
                    got_sv101 = 1
                    break
                default:
                    # should not be able to get here
                    break
            }

            if (got_sv180 && got_sv101) {
                print ""
                print subvol_101_oss "/%: " subvol_180_oss "/%"
                print "\t@echo 'CTOEDIT $<, $@...'" # ****TODO call $(gname...$@)
                print "\t@$(call TACL,$(CTOEDIT $<, $@))"
                print ""
                got_sv180 = 0
                got_sv101 = 0
            }
        } # end if for SUBVOL

    } #end if for SECTION

} #end action

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------

