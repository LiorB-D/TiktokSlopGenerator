# Tiktok Slop Generator

This bash project uses the OpenAI API and ffmpeg to generate tiktok slop.

### Setup

Running these scripts requires an OpenAI API Key.

Create a `.env` in the root of the folder and add a value for `OPENAI_API_KEY`

Make sure that you have [ffmpeg](https://www.ffmpeg.org/download.html) installed

### The Scripts

The flow is composed of 7 core scripts. I highly recommend running each step seperately and verifying the output. The steps are:

1. Generate Script
2. Generate Images
3. Generate Audio
4. Apply Ken Burns Affect to Images
5. Concatenate Clips
6. Add audio to video

To run the CLI, run `slop.sh`. The first time you run it, it will check for and if neccesary install `JQ`, a Bash JSON parser.

The output of each step will be in the `./assets` folder.

**1. Script Generation**

This script asks you for the topic that you want to make a video on. It writes the json output to a file named `transcript.json`. The json will be of the form:

```json
{
  "lines": [
    {
      "text": "The Election of 1800 was intense and historic.",
      "image": "American flag from 1800"
    },
    {
      "text": "John Adams, the incumbent, faced Thomas Jefferson.",
      "image": "Portrait of John Adams"
    },
    {
      "text": "Jefferson and Aaron Burr tied in the Electoral College.",
      "image": "Jefferson and Aaron Burr arguing on a presidential debate stage"
    },
    {
      "text": "The House of Representatives cast 36 ballots.",
      "image": "Interior of the House of Representatives. Representatives are voting and arguing."
    }
  ]
}
```

The `text` is what will be used for the TTS, while the `image` field will be used to generate the image.

**2. Generate Images**

The images are generated using DALLE-3 in `1024x1792`. As of 12/24/24, it costs $0.08 per image.

Images are saved to the `assets/images` folder, named `IMG_x.jpg` where x is its index in the list of clips

**3. Generate Audio**

Audio is currently generated using OpenAI's TTS, though its quality is meh so I will likely switch it to ElevenLabs soon

The text fields in the transcript are concatenated to form the transcript.

Audio is saved to `assets/audio.mp3`

**4. Apply Ken Burns**

This step generated a clip from each image using the Ken Burns effect (Zooming into a certain corner). The fffmpeg commands are pretty messy.

Clips are saved to `assets/clips/VID_x.mp4`

**5. Concatenate Clips**

This step uses ffmpeg to concatenate the clips into a singular video. The video is saved as `assets/vidWithoutAudio.mp4`

**6. Add Audio**

Finally, we use ffmpeg to slow down (or speed up) the video to the length of the audio, and combine the two into `finalVid.mp4`

### TODO

- Switch TTS model to Eleven Labs (Much higher quality, neglible price difference)
- Add CLI options for clearing assets
- Improve prompting for Dall-E and image description generation.
