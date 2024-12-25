#!/bin/bash
echo "Generating Transcript..."


echo "What should the video be about?"
read input_text


echo "Reading OpenAI API key from .env file..."


export $(egrep -v '^#' .env | xargs)


if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OpenAI API key not set."
  exit 1
fi

echo "API key read successfully: $OPENAI_API_KEY"


prompt="
You are writing a script for a short video.

Your script will consist of 6 lines of text. 
For each line of text that you generate, you will specify the sort of image that should be drawn on the screen.

The script should be engaging and informative, with each line flowing into the next.
The script should end with a conclusion that wraps up the video.

It should use engaging and ear-catching langauge to keep the viewer interested.


For example:
{
    text: 'The capital of France is Paris.',
    image: 'Eiffel Tower'
}
{
    text: 'Salah al Din al Ayubi was a great leader.',
    image: 'Salah al Din al Ayubi on horseback'
}

Each line of text should not exceed 15 words, but you can split up a sentence into multiple lines if needed.

There should not be more than 10 lines of text in total.

Image descriptions should be concrete things that can be drawn, not abstract concepts.
For example, generate people and objects, not maps, documents, or concepts.

Return a json of form {lines: [{text: '...', image: '...'}, ...]}

The video should be about: $input_text

"


echo "Sending prompt to OpenAI API...: $prompt"
response=$(curl "https://api.openai.com/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$(jq -n --arg prompt "$prompt" '{
        model: "gpt-4o",
        messages: [
            {
                role: "system",
                content: $prompt
            }
        ],
        response_format: {
            type: "json_object",
        }
    }')")

echo "Raw Response from OpenAI API:"
echo $response


transcript=$(echo $response | jq -r '.choices[0].message.content')

echo "Transcript generated successfully: $transcript"

echo "Saving transcript to file..."

echo $transcript > assets/transcript.json