#!/bin/bash

function show_help {
    echo "Usage: $0 [-y] [-v] [-f <frames per sec>] [-m <morped-pictures-inbetween>] [-r <xxx:xxx>] -s <source folder> -t <output file>"
}

function verbose {
    if [[ "$VERBOSE" == "1" ]]; then
        echo $@
    fi
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
CORES=4
OUTPUT_FILE="output"
VERBOSE=0
Y=0
CONTAINER="webm"
MORPH=0
FPS=20
SOURCEFOLDER="pictures"
RESOLUTION="1024:768"

while getopts "h:?:vyt:c:f:m:s:r:" opt; do
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
    f)  FPS=${OPTARG}
        ;;
    m)  MORPH=$OPTARG
        ;;
    r)  RESOLUTION=$OPTARG
        ;;
    s)  SOURCEFOLDER=$OPTARG
        ;;
    esac
done

# abs target names if not delivered
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
        verbose "OK, Captain…"
    else
        verbose "Exiting"
        exit 0
    fi
fi

# Starting 

verbose "Checking if we shall morph photos"
if (( $MORPH > 0 )); then
    verbose "Morping"
    MORPHFOLDER="/tmp/tempmorphfolder/"
    mkdir $MORPHFOLDER
    prevfile=""
    i=1
    for file in $(ls $SOURCEFOLDER); do
        if [[ "$prevfile" == "" ]]; then
            prevfile=$file  
            continue
        else
            verbose "Morfing $prevfile with $file"
            convert "$SOURCEFOLDER/$prevfile" "$SOURCEFOLDER/$file" -quality 70\
                -morph $MORPH "$MORPHFOLDER/${prevfile}_%05d.jpg"
            prevfile=$file  
        fi  
    done
    find $MORPHFOLDER | grep "00000.jpg" | xargs rm # as 0000 and 000<$MORPH> in next serie are equal
    verbose "Morfingfolder is new sourcefolder"
    SOURCEFOLDER=$MORPHFOLDER
fi

# gather names on files to be included in timelapse and sort by date and clock
FRAMESFILE="/tmp/framesfiletimelapse.txt"
rm $FRAMESFILE &> /dev/null
for file in $(ls -1 $SOURCEFOLDER | sort); do
    echo $SOURCEFOLDER$file >> $FRAMESFILE
done

verbose "Running mencoder, generationg $OUTPUT_FILE"
mencoder -ovc lavc -oac lavc -of lavf -lavfopts format=webm \
     -lavcopts threads=$CORES:vcodec=libvpx \
     -vf scale=$RESOLUTION -mf fps=$FPS \
     -ffourcc VP80 mf://@"$FRAMESFILE" -o $OUTPUT_FILE &>/dev/null


# cleaning up
verbose "Cleaning up"
rm $FRAMESFILE
rm -r $MORPHFOLDER

