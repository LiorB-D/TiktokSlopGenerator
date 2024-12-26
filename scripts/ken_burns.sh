echo "Applying Ken Burns effect to videos..."

NUM_IMAGES=$(ls ./assets/images | wc -l)
echo "Number of images: $NUM_IMAGES"




if [ ! -d "./assets/clips_nocap" ]; then
    mkdir ./assets/clips_nocap
fi

if [ ! -d "./assets/clips" ]; then
    mkdir ./assets/clips
fi


# Iterate through the images in the assets/images directory
for i in $(seq 1 $NUM_IMAGES)
do
    echo "Processing image $i..."




    # TODO: Test Generating zoom target random 

    if [ $((i % 2)) -eq 0 ]; then
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=0:y=0:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips_nocap/VID_NOCAP_$i.mp4
    elif [ $((i % 3)) -eq 0 ]; then
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=iw:y=ih:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips_nocap/VID_NOCAP_$i.mp4
    elif [ $((i % 5)) -eq 0 ]; then
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=0:y=ih:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips_nocap/VID_NOCAP_$i.mp4
    else 
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=iw:y=0:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips_nocap/VID_NOCAP_$i.mp4
    fi


     
    unescapedcaption=$(jq -r ".lines[$((i-1))].text" assets/transcript.json)
    caption=$(echo "$unescapedcaption" | sed "s/'//g")
    # Split the caption into an array of 4 words
    IFS=' ' read -r -a words <<< "$caption"
    lines=()
    line=""




    for word in "${words[@]}"; do
        if [[ $(echo "$line $word" | wc -w) -le 4 ]]; then
            line="$line $word"
        else
            lines+=("$line")
            line="$word"
        fi
    done
    lines+=("$line") # Add the last line
# Build the drawtext filters for each line
drawtext_filters=""
line_height=65 # Adjust as needed for spacing
font_size=65
for l in "${lines[@]}"; do
   if [ ${#l} -gt 25 ]; then
        font_size=50
    fi
done



for index in "${!lines[@]}"; do
    y_position="2*(h-text_h)/3+$((index * line_height))"

    drawtext_filters+="drawtext=text='${lines[$index]}':fontfile=./assets/font.ttf:fontsize=50:fontcolor=yellow:borderw=4:bordercolor=black:x=(w-text_w)/2:y=$y_position,"
done

# Remove the trailing comma
drawtext_filters=${drawtext_filters%,}

# Apply the drawtext filters
ffmpeg -i ./assets/clips_nocap/VID_NOCAP_$i.mp4 -y -vf "$drawtext_filters" -codec:a copy ./assets/clips/VID_$i.mp4
done

