#!/bin/bash

echo "Generating audio..."



export $(egrep -v '^#' .env | xargs)

if [ ! -f "assets/transcript.json" ]; then
  echo "Error: Transcript file not found."
  exit 1
fi

transcript=$(cat assets/transcript.json)

if [ -z "$transcript" ]; then
  echo "Error: Transcript is empty."
  exit 1
fi

transcriptText=$(jq -r '.lines[].text' assets/transcript.json | tr '\n' ' ')

echo "Transcript read successfully: $transcriptText"


PS3="Select a Text to Speech Model: "
options=("OPENAI" "ELEVENLABS")
select opt in "${options[@]}"; do
    case $opt in
        "OPENAI")
            echo "Selected OpenAI"

            if [ -z "$OPENAI_API_KEY" ]; then
              echo "Error: Open AI API key not set."
              exit 1
            fi

            echo "API key read successfully"


        response=$(curl -X POST https://api.openai.com/v1/audio/speech \
          -H "Authorization: Bearer $OPENAI_API_KEY" \
          -H "Content-Type: application/json" \
          -d "$(jq -n --arg transcriptText "$transcriptText" '{
                "model": "tts-1",
                "input": $transcriptText,
                "voice": "echo"
            }')" --write-out "%{http_code}" --output ./assets/audio.mp3)

            break
          ;;
        "ELEVENLABS")
            echo "Selected Eleven Labs"


          if [ -z "$ELEVEN_LABS_API_KEY" ]; then
            echo "Error: Eleven Labs API key not set."
            exit 1
          fi


          echo "Requesting audio from Eleven Labs API...: $ELEVEN_LABS_API_KEY"
          response=$(curl -X POST https://api.elevenlabs.io/v1/text-to-speech/onwK4e9ZLuTAKqWW03F9?output_format=mp3_44100_128 \
              -H "Xi-Api-Key: $ELEVEN_LABS_API_KEY" \
              -H "Content-Type: application/json" \
              -d "$(jq -n --arg transcriptText "$transcriptText" '{
                  "text": $transcriptText
              }')" --write-out "%{http_code}" --output ./assets/audio.mp3)


            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done



