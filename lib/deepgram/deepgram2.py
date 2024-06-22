#!/usr/bin/env python3
import os
from dotenv import load_dotenv
import logging
from deepgram.utils import verboselogs
from datetime import datetime
import httpx
import sys
import subprocess

from deepgram import (
    DeepgramClient,
    DeepgramClientOptions,
    PrerecordedOptions,
    FileSource,
)

load_dotenv()

def main():
    try:
        audio_file_path = subprocess.check_output(["yad", "--file", "--title", "Select Audio File"]).decode("utf-8").strip()

        # STEP 1 Create a Deepgram client using the API key in the environment variables
        config: DeepgramClientOptions = DeepgramClientOptions(
            verbose=verboselogs.SPAM,
        )
        deepgram: DeepgramClient = DeepgramClient("", config)
        # OR use defaults
        # deepgram: DeepgramClient = DeepgramClient()

        # STEP 2 Call the transcribe_file method on the prerecorded class
        with open(audio_file_path, "rb") as file:
            buffer_data = file.read()

        payload: FileSource = {
            "buffer": buffer_data,
        }

        options: PrerecordedOptions = PrerecordedOptions(
            model="nova-2",
            language="en",
            topics=True,
            intents=True,
            smart_format=True,
            punctuate=True,
            paragraphs=True,
            utterances=True,
            replace=["Quad 3: Claude3","Diffy:dify.ai", "53:phi3", "5 3:phi3", "top case:top-k", "cloud 3:Claude3", "5:phi3","Top case:top-k", "cloud 3:Claude3", "5:phi3",],
            diarize=True,
            filler_words=True,
            sentiment=True,
        )

        before = datetime.now()
        response = deepgram.listen.prerecorded.v("1").transcribe_file(
            payload, options, timeout=httpx.Timeout(300.0, connect=10.0)
        )
        after = datetime.now()

        # Get the output file name without the extension
        output_file_name = os.path.splitext(audio_file_path)[0]

        # Create the output file path with a .json extension
        output_file_path = output_file_name + ".json"

        # Write the JSON response to the output file
        with open(output_file_path, "w") as f:
            f.write(response.to_json(indent=4))

        print(f"Transcription saved to: {output_file_path}")
        print("")
        difference = after - before
        print(f"time: {difference.seconds}")

    except Exception as e:
        print(f"Exception: {e}")


if __name__ == "__main__":
    main()
