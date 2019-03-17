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
# build_dependencies_array
# ------------------------------------------------------------------------------
function build_dependencies_array(    name, file) {

    # Look for a "[#DEF :dep_name STRUCT" line...
    if (match($0, /#DEF[[:space:]]+:?[[:alpha:]][_[:alnum:]]*[[:space:]]\
+STRUCT/) > 0) { # regex must continue in first column
        $0 = substr($0, RSTART, RLENGTH)
        name = gensub(/:/, "", "g", $2)
        temp_array["name"] = name
    }

    # Look for a "FNAME f VALUE $VOL.SVOL.FILE;" line...
    if (match($0, /FNAME[[:space:]]+f[[:space:]]+VALUE/) > 0) {
        file = oss_fname_of(gensub(/;/, "", "g", $4))
        temp_array["file"] = file
    }
   
    # If we've got both quantities, put them into dependencies_array
    if (length(temp_array) == 2) {
        for (label in temp_array) {
            dependencies_array[temp_array["name"]][label] = temp_array[label]
        }
        delete temp_array
    }

}


# ------------------------------------------------------------------------------
# build_source_array
# ------------------------------------------------------------------------------
function build_source_array(    dir,sv180,sv101) {

    # Look for a "[#DEF :dir STRUCT" line...
    if (match($0, /#DEF[[:space:]]+:?[[:alpha:]][[:alnum:]]{0,7}[[:space:]]\
+STRUCT/) > 0) { # regex must continue in first column
        $0 = substr($0, RSTART, RLENGTH)
        dir = gensub(/:/, "", "g", $2)
        temp_array["dir"] = dir
    }

    # Look for a "SUBVOL sv180 VALUE $VOL.SVOL;" line...
    if (match($0, /SUBVOL[[:space:]]+sv180[[:space:]]+VALUE/) > 0) {
        sv180 = oss_subvol_of(gensub(/;/, "", "g", $4))
        temp_array["sv180"] = sv180
    }
    
    # Look for a "SUBVOL sv101 VALUE $VOL.SVOL;" line...
    if (match($0, /SUBVOL[[:space:]]+sv101[[:space:]]+VALUE/) > 0) {
        sv101 = oss_subvol_of(gensub(/;/, "", "g", $4))
        temp_array["sv101"] = sv101 
    }
    
    # If we've got all three quantities, put them into source_array
    if (length(temp_array) == 3) {
        for (label in temp_array) {
            source_array[temp_array["dir"]][label] = temp_array[label]
        }
        delete temp_array
    }

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
# oss_subvol_of
# returns: OSS-style name for a Guardian subvolume, e.g. /G/dev1/talsrc
#    The name returned is downshifted except for directory names E and G.
# parameter: Guardian subvolume name, e.g. $DEV1.TALSRC
#    A partially-qualified ("relative") subvolume name is acceptable.
#
# There is a LOT of duplication between this and function oss_fname_of(). There
# is very probably a neat groovy way to amalgamate the two, but currently I am
# struggling to see it. There seem to be too many possibilities for the
# argument string, 
# ------------------------------------------------------------------------------
function oss_subvol_of(GUARDIAN_SUBVOL) {

    # Shift filename to lower case
    guardian_subvol = tolower(GUARDIAN_SUBVOL)

    # Split sysname, volume, subvolume into an array
    delete array # ensure no previous version exists
    array_length = split(guardian_subvol, array, ".")
    
    # Create backarray, with elements of array reversed
    delete backarray # ensure no previous version exists
    for (i in array) {
        backarray[i] = array[(array_length - i) + 1]
    }
    
    # Get backarray elements; filename, subvolume, volume, sysname
    if (1 in backarray) {
        subvol = backarray[1]
    } else {
        subvol = ""
    }

    if (2 in backarray) { # remove "$" prefix
        volume = gensub(/\$/, "", 1, backarray[2])
    } else {
        volume = ""
    }

    if (3 in backarray) { # remove "\" prefix
        sysname = gensub(/\\/, "", 1, backarray[3])
    } else {
        sysname = ""
    }

    # Build OSS path
    oss_path = subvol
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
