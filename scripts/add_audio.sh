#!/bin/bash
echo "Fitting video to audio..."

audio_duration=$(ffprobe -i assets/audio.mp3 -show_entries format=duration -v quiet -of csv="p=0")
if [ -z "$audio_duration" ]; then
  echo "Error: Unable to get audio duration."
  exit 1
fi


video_duration=$(ffprobe -i assets/vidWithoutAudio.mp4 -show_entries format=duration -v quiet -of csv="p=0")
if [ -z "$video_duration" ]; then
  echo "Error: Unable to get video duration."
  exit 1
fi


echo "Audio duration: $audio_duration"
echo "Video duration: $video_duration"


speed_factor=$(echo "$audio_duration / $video_duration" | bc -l)

echo "Speed factor: $speed_factor"


# Set the video duration to match the audio duration by altering speed

ffmpeg -i assets/vidWithoutAudio.mp4 -y \
-filter_complex "[0:v]setpts=${speed_factor}*PTS[v]" \
-map "[v]" -c:v libx264 -an assets/VidWithRightLength.mp4


# Add the audio to the video

ffmpeg -i assets/VidWithRightLength.mp4 -i assets/audio.mp3 -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -strict experimental assets/finalVid.mp4
