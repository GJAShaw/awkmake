#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: printVariables.awk
# type: AWK program
# project: awkmake
# ------------------------------------------------------------------------------

BEGIN {
    IGNORECASE = 1
}

function makeVariable(LINE) {
    match(LINE, "=[_[:alpha:]][_[:alnum:]]*")
    VARIABLE_NAME = substr(LINE, RSTART + 1, RLENGTH - 1)
    match(LINE, "[$][[:alpha:]][[:alnum:]#.]*")
    FILE_NAME_GUARDIAN = substr(LINE, RSTART, RLENGTH)
    # ****TODO stuff to derive FILE_NAME_OSS
    return tolower(VARIABLE_NAME " := " FILE_NAME_GUARDIAN)
}

/\sADD\sDEFINE\s/ { print makeVariable($0) }

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
