curl \
  -X POST \
  -H "Authorization: Token $ENV{DEEPGRAM_API_KEY}" \
  -H "Content-Type: text/plain" \
  -d "Deepgram is great for real-time conversations… and also, you can build apps for things like customer support, logistics, and more. What do you think of the voices?" \
  "https://api.deepgram.com/v1/speak?model=aura-athena-en" \
  -o audio.mp3