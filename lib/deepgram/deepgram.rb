#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'

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

# Example usage
# Assuming you have a Deepgram JSON file named "deepgram_output.json"
# deepgram_output = DeepGram.process_deepgram_json(Pathname.new(ARGV[0].cleanpath.to_s))
# deepgram_output.each do |paragraph|
#   puts paragraph
# end


# Example usage with a file
# deepgram_output = DeepGram.process_deepgram_file('audio.wav')
# puts deepgram_output
