#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../bin', __dir__))

require 'summarize'

require 'knowlecule'

require 'tty-command'
require 'sinatra'

require 'nokogiri'
require 'open-uri'
require 'rack/session/pool'

set :logging, true
set :bind, '0.0.0.0'

class APIResponse
  def initialize(status, message, data)
    @status = status
    @message = message
    @data = data
  end

  def to_json(*a)
    {
      'id' => id,
      'name' => name,
      'url' => url
    }.to_json(*a)
  end
end

before do
  content_type :json
end

helpers do
  include Logging

  def extract_array_from_string(string)
    # Remove leading and trailing characters "[" and "]"
    clean_string = string.tr('{}', '')
    # Split the string into an array of floats
    clean_string.split(',')
  end
end

get '/' do
  return { todo: :implementation }.to_json
end

get '/dify' do
  data = JSON.parse(request.body.read.to_json)

  return json(data)
end

# Define a route for handling POST requests with text data
post '/tag' do
  content_type :json

  begin
    data = JSON.parse(request.body.read.to_json)
    sanitized_text = Text.sanatize(data)
    sections = Lingua::EN::Readability.new(sanitized_text)

    results = []

    sections.sentences.each do |sentences|
      tokenized_sentences = `~/Workspace/knowlecule/lib/pipeline/feature_extraction.rb "#{sentences}"`
      results << JSON.parse(tokenized_sentences)
    end

    results.to_json
  rescue StandardError => e
    logger.error "Error during tokenizing: #{e.message}"
    halt 404, { message: 'Error during tokenizing' }.to_json
  end
end

# Define a route for handling POST requests with text data
post '/summary' do
  content_type :json

  begin
    data = JSON.parse(request.body.read.to_json)

    sanitized_text = Text.sanatize(data)
    sections = Lingua::EN::Readability.new(sanitized_text)

    results = []

    sections.sentences.each do |sentence|
      chunked = Knowlecule::Pipeline::Chunker.new(sentence).perform
      content, topics = "#{chunked}".summarize(ratio: 75)
      results << JSON.parse(content)
    end

    p Lingua::EN::Readability.new(results.join(' ')).report

    results.join(' ').to_json
  rescue StandardError => e
    logger.error "Error during tokenizing: #{e.message}"
    halt 404, { message: 'Error during tokenizing' }.to_json
  end
end

# uniq_words = {}
# uniq_words[:words] = []

# sections.unique_words.each do |word|
#   uniq_words[:words] << word
# end

# @x.to_json

# p sanitized_text

# text = Lingua::EN::Readability.new(@sentences)

# puts "-----\n"

# text.sentences.each do |sentence|
#   p sentence
# end

# p sections
# text = Knowlecule::Pipeline::Text.new(sanitized_text)

# text.paragraphs.each do |paragraph|
#   seg = Knowlecule::Pipeline::Segmenter.new(paragraph).perform

#   seg.segment.each do |t|
#     tokenize = Knowlecule::Pipeline::Tokenizer.new(t).perform
#     p tokenize
#     puts '-------'
#     puts "\n"
#   end
# end

# text.sentences.each do |sentence|
#   begin
#     #sentence.gsub(/^\\|"|^\s/,"").chomp.strip.dup
#      tags = `~/Workspace/knowlecule/lib/pipeline/feature_extraction.rb "#{sentence}"`
#     puts tags
#   rescue FrozenError => e
#       p e
#   end
# end
