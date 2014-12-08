#!/bin/bash

if [[ "$1" == "" ]]; then
    echo "Specify targetfolder with dates as subfolders, populated with pictures"
    exit 1
fi

TARGETFOLDER=$1

for folder in $(ls $TARGETFOLDER); do
    #if [[ $folder =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    if [[ "$folder" == "2014-12-04" ]]; then
        date="$folder/"
        if ! [ -f "$TARGETFOLDER/$date".webm ]; then
            /home/felles/timelapse/timelapsetools/gentimelapse.bash -v -f 60 -m 5 -s $TARGETFOLDER/$date -t $TARGETFOLDER/$date".webm"
        fi
    fi
done
