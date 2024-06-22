#!/usr/bin/env ruby
# frozen_string_literal: true


module DeepGram
  module_function

end


# the transcript in paragraph form
cat $file|jq .results.channels[].alternatives[].paragraphs.transcript

# one long string
cat $file|jq .results.channels[].alternatives[].transcript

# # a list of unique intents
cat $file|jq .results.intents.segments[].intents[].intent|uniq
# a list of unique topics
cat $file|jq .results.topics.segments[].topics[].topic|uniq

# return each word with confidence score
cat $file | jq '.results.channels[].alternatives[].words[] | { word, confidence }'

# return a hash list of each segmented sentence
cat $file | jq '.results.channels[].alternatives[].paragraphs.paragraphs[].sentences[] | { text }'

# returns a hash list of paragraphs as an array of setences
cat $file | jq '.results.channels[].alternatives[].paragraphs.paragraphs[] | { paragraph: [.sentences[].text] }'

# segments with their labled categories|topics
cat $file | jq '.results.topics.segments[] | { text, topics: [.topics[] | { topic: .topic }] }'

# segments with their labled intents
cat $file | jq '.results.intents.segments[] | { text, intents: [.intents[] | { intent: .intent }] }'
