#!/bin/bash

echo "Welcome to the Slop Generator"

echo "Installing dependencies..."

./setup.sh

echo "Dependencies installed."
PS3="Please select a step: "

options=("Generate Transcript" "Generate Images" "Generate Audio" "Apply Ken Burns to Images" "Concatenate Videos Together" "Add Audio to Video" "Clear Assets" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Generate Transcript")
            ./scripts/generate_script.sh
            break
            ;;
        "Generate Images")
            ./scripts/generate_images.sh
            break
            ;;
        "Generate Audio")
            ./scripts/generate_audio.sh
            break
            ;;
        "Apply Ken Burns to Images")
            ./scripts/ken_burns.sh
            break
            ;;
        "Concatenate Videos Together")
            ./scripts/concat_clips.sh
            break
            ;;
        "Add Audio to Video")
            ./scripts/add_audio.sh
            break
            ;;
        "Clear Assets")
            ./scripts/clear_assets.sh
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