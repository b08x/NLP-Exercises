#!/usr/bin/env bash
set -x


#API_URL="https://api-inference.huggingface.co/models/distil-whisper/distil-large-v2"

API_URL="https://api-inference.huggingface.co/models/facebook/wav2vec2-base-960h"

function transcribe() {
  local mp3file=$1
  local max_retries=5
  for ((i = 0; i < max_retries; i++)); do

    text=$(gum spin -s line --title "transcribing $mp3file" --show-output -- curl $API_URL \
      -X POST \
      -H "Content-Type: multipart/form-data" \
      -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
      --data-binary "@${mp3file}" | jq '.text')

    if [[ "$text" != "null" ]]; then
      break
    fi

    notify-send -t 5000 -u critical "Transcription failed, retrying ($((max_retries - i)))..."

    gum spin -s line --title "waiting 10 seconds..." sleep 10
  done
  echo $text | xargs -0 | ruby -pe 'gsub(/^\s|!/, "")'
}

#########################################################################
#                             Greetings                                 #
#########################################################################
trap SIGINT SIGTERM ERR EXIT

gum style \
  --foreground 014 --border-foreground 024 --border double \
  --align center --width 50 --margin "1 2" --padding "2 4" \
  'Hello.' && sleep 1

xsel -cb

cd /tmp/splits

for mp3file in $(fd -e mp3); do

  text=$(transcribe $mp3file)

  if [[ "$text" == "null" ]]; then
    notify-send -t 5000 -u critical "Transcription failed"
  else
    text=$(echo $text | xargs -0 | ruby -pe 'gsub(/^\s/, "")')
    xsel -a -b <<<"$text"
    notify-send -t 10000 "transcription copied to clipboard"
    xsel -ob
  fi

done
