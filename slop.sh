#!/bin/bash

echo "Welcome to the Slop Generator"

echo "Installing dependencies..."

./setup.sh

echo "Dependencies installed."
PS3="Please select a step: "

options=("Generate Transcript" "Generate Images" "Generate Audio" "Apply Ken Burns to Images" "Concatenate Videos Together" "Add Audio to Video" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Generate Transcript")
            ./generate_script.sh
            break
            ;;
        "Generate Images")
            ./generate_images.sh
            break
            ;;
        "Generate Audio")
            ./generate_audio.sh
            break
            ;;
        "Apply Ken Burns to Images")
            ./ken_burns.sh
            break
            ;;
        "Concatenate Videos Together")
            ./concat_clips.sh
            break
            ;;
        "Add Audio to Video")
            ./add_audio.sh
            break
            ;;
        "Quit")
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done