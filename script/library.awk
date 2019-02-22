#!/usr/bin/gawk -f
# ------------------------------------------------------------------------------
# file: library.awk
# type: GAWK function library file
# project: awkmake
#
# ------------------------------------------------------------------------------

# ----
#BEGIN
# ----
BEGIN {
    IGNORECASE = 1 # gawk feature
}

# ------------------------------------------------------------------------------
# oss_fname
# returns: OSS-style name for a Guardian file, e.g. /G/dev1/talsrc/hello
# parameter: Guardian filename, e.g. $DEV1.TALSRC.HELLO
# ------------------------------------------------------------------------------
function oss_fname (GUARDIAN_FNAME) {

    # Shift filename to lower case
    guardian_fname = tolower(GUARDIAN_FNAME)

    # Split sysname, volume, subvolume and filename into an array
    delete array # ensure no previous version exists
    array_length = split(guardian_fname, array, ".")
    
    # Create backarray, with elements of array reversed
    delete backarray # ensure no previous version exists
    for (i in array) {
        backarray[i] = array[(array_length - i) + 1]
    }
    
    # Get backarray elements; filename, subvolume, volume, sysname
    if (1 in backarray) {
        file = backarray[1]
    } else {
        file = ""
    }

    if (2 in backarray) {
        subvolume = backarray[2]
    } else {
        subvolume = ""
    }

    if (3 in backarray) { # remove "$" prefix
        volume = gensub(/\$/, "", 1, backarray[3])
    } else {
        volume = ""
    }

    if (4 in backarray) { # remove "\" prefix
        sysname = gensub(/\\/, "", 1, backarray[4])
    } else {
        sysname = ""
    }

    # Build OSS path
    oss_path = file
    if (length(subvolume) > 0)
        oss_path = subvolume "/" oss_path
    if (length(volume) > 0)
        oss_path = "/G/" volume "/" oss_path
    if (length(sysname) > 0)
        oss_path = "/E/" sysname oss_path
    
    # Return
    return oss_path

}

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
