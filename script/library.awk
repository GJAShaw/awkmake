# ------------------------------------------------------------------------------
# file: library.awk
# type: GAWK function library file
# project: gawkmake
# ------------------------------------------------------------------------------

# ----
#BEGIN
# ----
BEGIN {
    IGNORECASE = 1 # gawk feature
}


# ------------------------------------------------------------------------------
# build_buildtacl_array
# ------------------------------------------------------------------------------
function build_buildtacl_array() {

    if (match($0, /FNAME[[:space:]]+bt1[80][01][[:space:]]+VALUE/) > 0) {
        buildtacl_array[$2] = gensub(/;/, "", "g", $4)
    }
   
}


# ------------------------------------------------------------------------------
# build_ddldict_array
# Similar to build_targets_arrays. Perhaps some refactoring would be
# good, as a future enhancement; combine the two functions somehow.
# ------------------------------------------------------------------------------
function build_ddldict_array(    name, dlabel, dname) {

    # Look for a "[#DEF :target STRUCT" line...
    if (match($0, /#DEF[[:space:]]+:?[[:alpha:]][_[:alnum:]]*[[:space:]]+\
+STRUCT/) > 0) { # regex must continue in first column
        $0 = substr($0, RSTART, RLENGTH)
        name = gensub(/:/, "", "g", $2)
        ddldict_array["name"] = name
    }

    # Look for a "FNAME xxxx VALUE $VOL.SVOL.FILE;" line...
    # xxxx could be file or logto
    if (match($0, /FNAME[[:space:]]+[[:alpha:]]+[[:space:]]+VALUE/) > 0) {
        ddldict_array[$2] = gensub(/;/, "", "g", $4)
    }
   
    # Look for a "STRUCT dependencies;" line...
    if (match($0, /STRUCT[[:space:]]+dependencies[[:space:]]*;/) > 0) {
        want_dependencies = 1
    }

    # Look for a 'CHAR d01(0:30) VALUE "gsddl_src";' line...
    if (match($0, /CHAR[[:space:]]+[[:alnum:]]+\(0:30\)[[:space:]]+\
VALUE/) > 0) { # regex must continue in first column
        dlabel = gensub(/(.+)\(.+/, "\\1", "g" $2)
        dname  = gensub(/[;\"]/, "", "g", $4)
        ddldict_array[dlabel] = dname
    }

    # Look for "END;", after we started getting dependencies
    if (match($0, /^[[:space:]]+END[[:space:]]*;/) > 0 && want_dependencies) {
        want_dependencies = 0
    }

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
        file = gensub(/;/, "", "g", $4)
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
# build_sourcemap_array
# ------------------------------------------------------------------------------
function build_sourcemap_array(    dir, sv180, sv101) {

    # Look for a "[#DEF :dir STRUCT" line...
    if (match($0, /#DEF[[:space:]]+:?[[:alpha:]][[:alnum:]]{0,7}[[:space:]]\
+STRUCT/) > 0) { # regex must continue in first column
        $0 = substr($0, RSTART, RLENGTH)
        dir = gensub(/:/, "", "g", $2)
        temp_array["dir"] = dir
    }

    # Look for a "SUBVOL sv180 VALUE $VOL.SVOL;" line...
    if (match($0, /SUBVOL[[:space:]]+sv180[[:space:]]+VALUE/) > 0) {
        sv180 = gensub(/;/, "", "g", $4)
        temp_array["sv180"] = sv180
    }
    
    # Look for a "SUBVOL sv101 VALUE $VOL.SVOL;" line...
    if (match($0, /SUBVOL[[:space:]]+sv101[[:space:]]+VALUE/) > 0) {
        sv101 = gensub(/;/, "", "g", $4)
        temp_array["sv101"] = sv101 
    }

    # If we've got all three quantities, put them into sourcemap_array
    if (length(temp_array) == 3) {
        for (label in temp_array) {
            sourcemap_array[temp_array["dir"]][label] = temp_array[label]
        }
        delete temp_array
    }

}


# ------------------------------------------------------------------------------
# build_targets_arrays
# Similar to build_ddldict_array. Perhaps some refactoring would be
# good, as a future enhancement; combine the two functions somehow.
# ------------------------------------------------------------------------------
function build_targets_arrays(    \
    name, deliverable, secure, dlabel, dname) {

    # Look for a "[#DEF :target STRUCT" line...
    if (match($0, /#DEF[[:space:]]+:?[[:alpha:]][_[:alnum:]]*[[:space:]]+\
+STRUCT/) > 0) { # regex must continue in first column
        $0 = substr($0, RSTART, RLENGTH)
        name = gensub(/:/, "", "g", $2)
        temp_array["name"] = name
    }

    # Look for a "CHAR deliverable" line...
    if (match($0, /CHAR[[:space:]]+deliverable[[:space:]]+VALUE/) > 0) {
        deliverable = gensub(/[";]/, "", "g", $4)
        temp_array["deliverable"] = deliverable
    }

    # Look for a "FNAME xxxx VALUE $VOL.SVOL.FILE;" line...
    # xxxx could be file, logto or secure
    if (match($0, /FNAME[[:space:]]+[[:alpha:]]+[[:space:]]+VALUE/) > 0) {
    
        switch ($2) {
        
            case "file":
            case "logto":
                temp_array[$2] = gensub(/;/, "", "g", $4)
                break
            
            case "secure":
                secure = gensub(/;/, "", "g", $4)
                if (match(secure, /^NONE$/) == 0) {
                    secure_array[temp_array["name"]] = secure
                }
                break
                
            # no default case
        }
        
    }
   
    # Look for a "STRUCT dependencies;" line...
    if (match($0, /STRUCT[[:space:]]+dependencies[[:space:]]*;/) > 0) {
        want_dependencies = 1
    }

    # Look for a 'CHAR d01(0:30) VALUE "gstalsrc_hello";' line...
    if (match($0, /CHAR[[:space:]]+[[:alnum:]]+\(0:30\)[[:space:]]+\
VALUE/) > 0) { # regex must continue in first column
        dlabel = gensub(/(.+)\(.+/, "\\1", "g" $2)
        dname  = gensub(/[;\"]/, "", "g", $4)
        temp_array[dlabel] = dname
    }

    # Look for "END;", after we started getting dependencies
    if (match($0, /^[[:space:]]+END[[:space:]]*;/) > 0 && want_dependencies) {
        for (label in temp_array) {
            targets_array[temp_array["name"]][label] = temp_array[label]
        }
        want_dependencies = 0
        delete temp_array
    }

}

                        
# ------------------------------------------------------------------------------
# oss_fname_of
# returns: OSS-style name for a Guardian file, e.g. /G/dev1/talsrc/hello
#    The filename returned is downshifted except for directory names E and G.
# parameter: Guardian filename, e.g. $DEV1.TALSRC.HELLO
#    A partially-qualified ("relative") filename is acceptable.
# ------------------------------------------------------------------------------
function oss_fname_of(GUARDIAN_FNAME,    array, array_length, backarray, file,\
   subvolume, volume, sysname, oss_path) {

    # Split sysname, volume, subvolume and filename into an array
    array_length = split(tolower(GUARDIAN_FNAME), array, ".")
    
    # Create backarray, with elements of array reversed
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
function oss_subvol_of(GUARDIAN_SUBVOL,    array, array_length, backarray,\
   subvol, volume, sysname, oss_path) {

    # Split sysname, volume, subvolume into an array
    delete array # ensure no previous version exists
    array_length = split(tolower(GUARDIAN_SUBVOL), array, ".")
    
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
