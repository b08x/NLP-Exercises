#!/usr/bin/env ruby

# require_relative 'pipeline/text/graph'
require_relative 'pipeline/segment_tokenize'
# require_relative 'pipeline/feature_extraction'
require_relative 'pipeline/hypernyms'
require_relative 'pipeline/ldamodeler'

require 'lingua'

module Text
  include Logging

  module_function

  def sanatize(text)
    clean_text = text.gsub(/\r/,' ').gsub(/\n/,' ').gsub(/\s+/,' ')
    clean_text.gsub!("\t\r ", '')
    clean_text.gsub!('-­‐', '-')
    clean_text.gsub!("•", '')
    clean_text.gsub!("●", '')
    clean_text.gsub!("\n\n", '#keep#')
    clean_text.gsub!("\n", ' ')
    # Fix for an incompatible space character.
    clean_text.gsub!(" ", ' ')
    clean_text.gsub!('#keep#', "\n\n")
    clean_text.gsub!("   ",' ')
    return clean_text
  end

end


#content = Lingua::EN::Readability.new(text)

#content.paragraphs.each {|x| p x; puts "\n\n"}

# p content
#p content.paragraphs
#p content.sentences
# p content.words
# p content.unique_words
# p content.report

# content.sentences.each do |sentence|
#   begin
#     s = sentence.gsub(/^\\|"|^\s/,"").chomp.strip.dup
#     p Knowlecule::Pipeline::Chunker.perform(s)

#   rescue FrozenError => e
#     p e
#   end
# end

require 'linguistics'
require 'pragmatic_tokenizer'
require 'tomoto'
require 'ruby-spacy'









module DeepGramParsing
  def parse_json(file)
    raise NotImplementedError
  end
end

class Deepgram
  include DeepGramParsing

  attr_accessor :transcript, :paragraphs, :intents, :topics

  def initialize(file)
    @json_data = JSON.parse(File.read(file))
    @paragraphs = []
    @intents = []
    @topics = []
  end

  def parse_json
    transcript
    paragraphs
    topics
    intents
  end

  def transcript
    @transcript = @json_data["results"]["channels"][0]['alternatives'][0]['transcript']
  end

  def paragraphs
    @paragraphs = @json_data["results"]["channels"][0]['alternatives'][0]['paragraphs']['transcript'].strip.split("\n\n")
  end

  def topics
    @json_data["results"]["topics"]["segments"].each {|seg| @topics << seg["topics"][0]["topic"] }
    @topics.uniq!
  end

  def intents
    @json_data["results"]["intents"]["segments"].each {|seg| @intents << seg["intents"][0]["intent"] }
    @intents.uniq!
  end

end



longtext = Item.new('/home/b08x/Recordings/staging/test0001/2024-05-22_23-13-31_deepgram.json')

@text = Deepgram.new(longtext.path)
@text.parse_json

# @tt = []
# @text.paragraphs.each do |para|
#    @tt << Tokenizer.tokenize(para)
# end

@extractor = SpacyFeatureExtractor.new

@things = []

@text.paragraphs[0..3].each do |para|
  @things << @extractor.dependencies(para)
end

p @things
#
#
# exit

# modeler = Modeler.new(Dir.pwd)
#
# @tt.each do |tokens|
#   modeler.add(tokens)
# end
# modeler.train
# modeler.summary
#
# puts modeler.model.topic_words
#
#




# ---

#  # return each word with confidence score
#  def words_with_confidence(file)
#   `cat #{file} | jq -r '.results.channels[].alternatives[].words[] | { word, confidence }'`
#     .split("\n")
#     .map { |word_data| eval(word_data) } # Use eval to parse the string into a hash
# end

# # return a hash list of each segmented sentence
# def segmented_sentences(file)
#   `cat #{file} | jq -r '.results.channels[].alternatives[].paragraphs.paragraphs[].sentences[] | { text }'`
#     .split("\n")
#     .map { |sentence_data| eval(sentence_data) } # Use eval to parse the string into a hash
# end

# # returns a hash list of paragraphs as an array of setences
# def paragraphs_as_sentences(file)
#   `cat #{file} | jq -r '.results.channels[].alternatives[].paragraphs.paragraphs[] | { paragraph: [.sentences[].text] }'`
#     .split("\n")
#     .map { |paragraph_data| eval(paragraph_data) } # Use eval to parse the string into a hash
# end

# # segments with their labled categories|topics
# def segments_with_topics(file)
#   `cat #{file} | jq -r '.results.topics.segments[] | { text, topics: [.topics[] | { topic: .topic }] }'`
#     .split("\n")
#     .map { |segment_data| eval(segment_data) } # Use eval to parse the string into a hash
# end

# # segments with their labled intents
# def segments_with_intents(file)
#   `cat #{file} | jq -r '.results.intents.segments[] | { text, intents: [.intents[] | { intent: .intent }] }'`
#     .split("\n")
#     .map { |segment_data| eval(segment_data) } # Use eval to parse the string into a hash
# end
