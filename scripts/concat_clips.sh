#!/bin/bash

echo "Concatenating videos together..."

echo "Assembling file list"

# Need to generate a file list of the clpis for ffmpeg read from
ls ./assets/clips/VID_*.mp4 | sed "s|^./assets/|file '|" | sed "s|\$|'|" > ./assets/clip_list.txt


echo "Concatenating clips"
ffmpeg -f concat -safe 0 -i ./assets/clip_list.txt -y -c copy ./assets/vidWithoutAudio.mp4
