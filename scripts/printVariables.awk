#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: printVariables.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source, looking for ADD DEFINE commands, and from them
# creates Make variable definitions. For example:
#   ADD DEFINE =MY_FILE, FILE $EARL.LINCOLN.CATFILE
# is printed as
#   my_file := /G/earl/lincoln/catfile
# ------------------------------------------------------------------------------

BEGIN {
    IGNORECASE = 1 # gawk feature
}

function makeVariable(LINE) {

    # derive Make variable name from the TACL define name
    match(LINE, "=[_[:alpha:]][_[:alnum:]]*")
    variable_name = tolower(substr(LINE, RSTART + 1, RLENGTH - 1))

    # get filename in Guardian format - $volume.subvol.file
    match(LINE, "[$][[:alpha:]][[:alnum:]]{0,6}.[[:alpha:]][[:alnum:]]{0,7}.\
[[:alpha:]][[:alnum:]]{0,7}") # regex must be continued in first column
    file_name_guardian = tolower(substr(LINE, RSTART, RLENGTH))

    # derive filename in OSS format - /G/volume/subvol/file
    file_name_oss = gensub(/\$(.+)\.(.+)\.(.+)/, "/G/\\1/\\2/\\3", "g", \
      file_name_guardian)

    # return Make variable definition
    return variable_name " := " file_name_oss

}

# Get ADD DEFINEs for diskfiles only, not spooler locations (hence [^#]+)
/\sADD\sDEFINE\s[^#]+$/ { print makeVariable($0) }

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
