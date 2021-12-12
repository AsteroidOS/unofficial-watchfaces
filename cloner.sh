#!/bin/bash
# clone watchface changing names where required

# remember source and dest, trimming trailing / if needed
SOURCE=$(echo $1 | sed 's:/*$::')
DEST=$(echo $2 | sed 's:/*$::')

function showHelp {
    cat << EOF
./clone.sh source destination
Clone a existing "source" watchface to a new "destination" watchface.
The script copies and renames files that contain the "source" name and 
updates the watchface qml file to point to the renamed sources.

EOF
}

# the three-argument form is only intended to be used internally
if [ -f "$3" ] ; then
    if [[ "$3" == *.qml ]] ; then
        sed "s/$SOURCE/$DEST/g" "$3" > "${3//$SOURCE/$DEST}"
        rm "$3"
    else
        mv "$3" "${3//$SOURCE/$DEST}"
    fi
    exit
fi

if [ "$#" != "2" ] ; then
    showHelp
    exit
fi

if [ ! -d "$SOURCE" ] ; then
    echo "Error:  $SOURCE does not exist, exiting program"
    exit
fi

if [ -e "$DEST" ] ; then
    echo "Error:  $DEST already exists, exiting program"
    exit
fi

# copy all of the files
cp -r "${SOURCE}" "${DEST}"

# rename any file that contains the source dir name 
find "${DEST}" -type f -iname "*${SOURCE}*" -execdir "$(pwd)/cloner.sh" "${SOURCE}" "${DEST}" '{}' \;
