#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: createBuildmk.awk
# type: GAWK program
# project: awkmake
#
# This program reads TACL source and creates a GNU Makefile
# ------------------------------------------------------------------------------

BEGIN {
    IGNORECASE = 1 # gawk feature
}


# -------------
# Define functions
# -------------

function printDiskfilesSource(line) {
    # stub - do nothing, for now
}

function printDiskfilesTarget(line) {
    # stub - do nothing, for now
}

function printDiskfilesOther(line) {
    print "wazzock!"
}

function printDependencies(line) {
    # stub - do nothing, for now
}

function printRecipe(line) {
    # stub - do nothing, for now
}

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
/^.*$/ {
switch (section) {
    case "define_diskfiles_source":
        printDiskfilesSource($0)
        break
    case "define_diskfiles_target":
        printDiskfilesTarget($0)
        break
    case "define_diskfiles_other":
        printDiskfilesOther($0)
        break
    case "[[:alnum:]_]+_dep":
        printDependencies($0)
        break
    case "[[:alnum:]_]+_rec":
        printRecipe($0)
        break
    default:
        break
}
}

#define_everything
#define_flags
#define_texts
#define_diskfiles_repository_source
#define_diskfiles_other
#define_spooler_locations
#define_defines
#define_assigns
#define_params
#define_gs100obj_hello_rule
#define_gs100exe_hello_rule


# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
