#!/bin/bash

function show_help {
    echo "Usage: $0 [-y] [-v] [-c <webm|avi>] [-f <frames per sec>] [-m <morped-pictures-inbetween>] [-r <xxx:xxx>] -s <source folder> -t <output file>"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.



# Initialize our own variables:
OUTPUT_FILE="output"
VERBOSE=0
Y=0
CONTAINER="webm"
MORPH=0
FPS=20
SOURCEFOLDER="pictures"
RESOLUTION="1024:768"

while getopts "h?vytcfmr:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  VERBOSE=1
        ;;
    y)  Y=1
        ;;
    t)  OUTPUT_FILE=$OPTARG
        ;;
    c)  CONTAINER=$OPTARG
        ;;
    f)  FPS=$OPTARG
        ;;
    m)  MORPH=$OPTARG
        ;;
    r)  RESOLUTION=$OPTARG
        ;;
    esac
done

if [[ ${SOURCEFOLDER:0:1} != "/" ]] ; then
     SOURCEFOLDER=$(pwd)/$SOURCEFOLDER
fi

if [[ ${OUTPUT_FILE:0:1} != "/" ]] ; then
     OUTPUT_FILE=$(pwd)/$OUTPUT_FILE
fi

OUTPUT_FILE="$OUTPUT_FILE.$CONTAINER"

if [[ "$Y" == "0" ]]; then
    echo "Add -y as argument if you dont want this check."
    echo "Running with pictures from $SOURCEFOLDER, adding $MORPH pctures
          between each picture, $FPS frames per sec, $CONTAINER as 
          format and $RESOLUTION as resolution. Outputfile $OUTPUT_FILE"
    read -r -p "Continue? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo "OK, Captain…"
    else
        exit 0
    fi
fi

# Starting 

if [[ "$VERBOSE" ]]; then
    echo shit
fi

