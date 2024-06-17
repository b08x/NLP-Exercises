#!/usr/bin/env ruby
# frozen_string_literal: true


module DeepGram
  module_function

end


# just the transcript
cat 2024-05-22_03-22-03-deepgram.json|jq .results.channels[].alternatives[].transcript


# to list words, and their start and end times, etc:
╰$ cat 2024-05-22_03-22-03-deepgram.json|jq .results.channels[].alternatives[].words[]


╰$ cat 2024-05-22_03-22-03-deepgram.json|jq .results.topics.segments[].topics[].topic

╰$ cat 2024-05-22_03-22-03-deepgram.json|jq .results.topics.segments[].text


╰$ cat 2024-05-22_03-22-03-deepgram.json|jq .results.intents.segments[].text

╰$ cat 2024-05-22_03-22-03-deepgram.json|jq .results.intents.segments[].intents[].intent
