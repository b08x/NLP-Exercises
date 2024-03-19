#!/usr/bin/env python
import numpy as np
import argparse
import librosa
import os
import tempfile

def split_on_silence(audio_path, silence_threshold=-50, silence_duration=10):
    """
    Splits an audio file on silence.

    Parameters
    ----------
    audio_path : str
        Path to the audio file.
    silence_threshold : int
        The energy level below which silence is detected.
    silence_duration : int
        The minimum duration of silence (in seconds) required to split the audio.

    Returns
    -------
    list of str
        List of audio file paths after splitting.
    """
    # Load the audio file
    y, sr = librosa.load(audio_path, sr=None)

    # Extract Mel-spectrogram features
    S = librosa.feature.melspectrogram(y=y, sr=sr, n_mels=128)

    # Convert to decibels
    log_S = librosa.power_to_db(S, ref=np.max)

    # Find indices where the energy is below the threshold
    below_threshold = np.where(log_S < silence_threshold)[0]

    # Find the indices where the silence duration is greater than the threshold
    split_indices = np.where(np.diff(below_threshold) > silence_duration)[0] + 1

    # Create a temporary output directory
    temp_dir = tempfile.TemporaryDirectory()

    # Split the audio file
    file_parts = []
    start, end = 0, below_threshold[0]
    for i in split_indices:
        # Write the current segment to a file
        segment_name = os.path.join(temp_dir.name, f"part_{i}.wav")
        librosa.output.write_wav(segment_name, y[start:end], sr)

        # Update the start and end indices
        start, end = end, below_threshold[i]

    # Write the last segment to a file
    segment_name = os.path.join(temp_dir.name, f"part_{len(split_indices)}.wav")
    librosa.output.write_wav(segment_name, y[start:], sr)

    # Return the list of split files
    return [os.path.join(temp_dir.name, f"part_{i}.wav") for i in range(len(split_indices) + 1)]

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Split an audio file on silence.")
    parser.add_argument("input_file", help="Path to the input audio file.")
    parser.add_argument("temp_dir", help="Path to the temporary directory for split files.")
    args = parser.parse_args()

    split_files = split_on_silence(args.input_file, args.temp_dir)
    print("Split files:")
    for i, split_file in enumerate(split_files):
        print(f"{i+1}. {split_file}")