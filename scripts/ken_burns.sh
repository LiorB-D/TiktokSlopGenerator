echo "Applying Ken Burns effect to videos..."

NUM_IMAGES=$(ls ./assets/images | wc -l)
echo "Number of images: $NUM_IMAGES"

# Iterate through the images in the assets/images directory
for i in $(seq 1 $NUM_IMAGES)
do
    echo "Processing image $i..."

    

    if [ $((i % 2)) -eq 0 ]; then
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=0:y=0:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips/VID_$i.mp4
    elif [ $((i % 3)) -eq 0 ]; then
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=iw:y=ih:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips/VID_$i.mp4
    elif [ $((i % 5)) -eq 0 ]; then
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=0:y=ih:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips/VID_$i.mp4
    else 
        ffmpeg \
        -loop 1 -i \
        ./assets/images/IMG_$i.jpg -y \
        -filter_complex '[0]scale=1024:-2,setsar=1:1[out];[out]crop=1024:1792[out];[out]scale=1024:-1,zoompan=z=zoom+0.001:x=iw:y=0:d=250:s=1024x1792:fps=25[out]' \
        -acodec aac -vcodec libx264 \
        -map [out] -map 0:a? -pix_fmt yuv420p -r 25 -t 5 ./assets/clips/VID_$i.mp4
    fi
done

