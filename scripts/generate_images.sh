#!/bin/bash

echo "Generating images from transcript..."


export $(egrep -v '^#' .env | xargs)

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OpenAI API key not set."
  exit 1
fi

if [ ! -f "assets/transcript.json" ]; then
  echo "Error: Transcript file not found."
  exit 1
fi

transcript=$(cat assets/transcript.json)

if [ -z "$transcript" ]; then
  echo "Error: Transcript is empty."
  exit 1
fi

echo "Transcript read successfully: $transcript"

echo "What style should the images be in?"
read style



echo "Generating images from the transcript..."

index=1
jq -c '.lines[]' assets/transcript.json | while read -r line; do
    description=$(echo "$line" | jq -r '.image')


    prompt="
    Generate an 1024x1792 image of $description in the style of $style.
    "

    # Skip if IMG_$index.jpg already exists

    if [ -f "assets/images/IMG_$index.jpg" ]; then
        echo "Image for '$description' already exists as IMG_$index.jpg. Skipping..."
        index=$((index + 1))
        continue
    fi
    
    response=$(curl "https://api.openai.com/v1/images/generations" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$(jq -n --arg prompt "$prompt" '{
        "model": "dall-e-3",
        "prompt": $prompt,
        "n": 1,
        "size": "1024x1792",
        "response_format": "b64_json"
    }')")

b64Json=$(echo $response | jq -r '.data[0].b64_json')

  if [ -n "$b64Json" ]; then
    echo "$b64Json" | base64 -d > "assets/images/IMG_$index.jpg"
    echo "Saved image for '$description' as IMG_$index.jpg"
  else
    echo "Failed to generate image for '$description': $response"
  fi

    index=$((index + 1))
done


echo "Images generated successfully."