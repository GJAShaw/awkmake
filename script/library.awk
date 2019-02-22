# ------------------------------------------------------------------------------
# file: library.awk
# type: GAWK function library file
# project: awkmake
# ------------------------------------------------------------------------------

# ----
#BEGIN
# ----
BEGIN {
    IGNORECASE = 1 # gawk feature
}

# ------------------------------------------------------------------------------
# guardian_fname_of
# returns: Guardian-style filename, e.g. $DEV1.TALSRC.HELLO
#    The filename returned is not case-shifted.
# parameter: OSS-style name for a Guardian file, e.g. /G/dev1/talsrc/hello
#    A partially-qualified ("relative") filename is acceptable.
#
# I tried writing this with one gensub() and two sub() calls, but got bogged
# down in regex failure, so I resorted to an array method.
# ------------------------------------------------------------------------------
function guardian_fname_of(oss_fname) {

    # Split sysname, volume, subvolume and filename into an array
    delete array # ensure no previous version exists
    array_length = split(guardian_fname, array, "/")
    
    # Define an empty string
    file = ""
    
    # Check for system name
    if (1 in array) {
        if (array[1] == "E") {
            if (2 in array) {
                sysname = array[2]
                delete array[1]
                delete array[2]
            } else {
                sysname = ""
            }
        }
    }
    
    # ****TODO later: finish, rewrite, whatever. I need a break from this.
    return "workInProgress"

}

# ------------------------------------------------------------------------------
# oss_fname_of
# returns: OSS-style name for a Guardian file, e.g. /G/dev1/talsrc/hello
#    The filename returned is downshifted except for directory names E and G.
# parameter: Guardian filename, e.g. $DEV1.TALSRC.HELLO
#    A partially-qualified ("relative") filename is acceptable.
# ------------------------------------------------------------------------------
function oss_fname_of(GUARDIAN_FNAME) {

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
