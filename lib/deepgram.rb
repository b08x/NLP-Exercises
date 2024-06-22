#!/usr/bin/env ruby
# frozen_string_literal: true

module DeepGram
  module_function

  # the transcript in paragraph form
  def transcript_paragraphs(file)
    `cat #{file} | jq .results.channels[].alternatives[].paragraphs.transcript`
  end

  # one long string
  def transcript_string(file)
    `cat #{file} | jq .results.channels[].alternatives[].transcript`
  end

  # a list of unique intents
  def unique_intents(file)
    `cat #{file} | jq .results.intents.segments[].intents[].intent | uniq`
  end

  # a list of unique topics
  def unique_topics(file)
    `cat #{file} | jq .results.topics.segments[].topics[].topic | uniq`
  end

  # return each word with confidence score
  def words_with_confidence(file)
    `cat #{file} | jq '.results.channels[].alternatives[].words[] | { word, confidence }'`
  end

  # return a hash list of each segmented sentence
  def segmented_sentences(file)
    `cat #{file} | jq '.results.channels[].alternatives[].paragraphs.paragraphs[].sentences[] | { text }'`
  end

  # returns a hash list of paragraphs as an array of setences
  def paragraphs_as_sentences(file)
    `cat #{file} | jq '.results.channels[].alternatives[].paragraphs.paragraphs[] | { paragraph: [.sentences[].text] }'`
  end

  # segments with their labled categories|topics
  def segments_with_topics(file)
    `cat #{file} | jq '.results.topics.segments[] | { text, topics: [.topics[] | { topic: .topic }] }'`
  end

  # segments with their labled intents
  def segments_with_intents(file)
    `cat #{file} | jq '.results.intents.segments[] | { text, intents: [.intents[] | { intent: .intent }] }'`
  end
end
