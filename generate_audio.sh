#!/bin/bash

echo "Generating audio..."

export $(egrep -v '^#' .env | xargs)

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: Open AI API key not set."
  exit 1
fi

echo "API key read successfully"

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


response=$(curl -X POST https://api.openai.com/v1/audio/speech \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg transcriptText "$transcriptText" '{
         "model": "tts-1",
         "input": $transcriptText,
         "voice": "echo"
     }')" --write-out "%{http_code}" --output ./assets/audio.mp3)





