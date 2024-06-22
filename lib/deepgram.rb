#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pragmatic_tokenizer'
require 'tomoto'
require 'composable_operations'
require 'json'
require 'open3'

module DeepGram
  module_function

  class DeepgramProcessor < ComposableOperations::Operation
    processes :json_data

    property :json_data, required: true

    before do
      @transcript = []
    end
    def execute
      # Extract the transcript from the JSON data
      @transcript << json_data[:json_data]['results']['channels'][0]['alternatives'][0]['paragraphs']
      # Return the transcript
      @transcript.map! { |paragraph| paragraph['transcript'].strip }
      return @transcript
    end
  end


  class DeepgramTopics < ComposableOperations::ComposedOperation
    use DeepgramProcessor
  end

  def process_deepgram_json(file)
    json_data = JSON.parse(File.read(file))
    DeepgramTopics.new(json_data: json_data).perform
  end

  def process_deepgram_file(file)
    # Use Open3 to capture the output of the command
    stdout, stderr, status = Open3.capture3("deepgram transcribe --url #{file}")
    # Check if the command was successful
    if status.success?
      # Parse the JSON output
      json_data = JSON.parse(stdout)
      # Process the JSON data
      process_deepgram_json(json_data)
    else
      # Handle the error
      puts "Error transcribing file: #{stderr}"
    end
  end
end

# Example usage
# Assuming you have a Deepgram JSON file named "deepgram_output.json"
deepgram_output = DeepGram.process_deepgram_json(Pathname.new(ARGV[0].cleanpath.to_s))
deepgram_output.each do |paragraph|
  puts paragraph
end


# Example usage with a file
# deepgram_output = DeepGram.process_deepgram_file('audio.wav')
# puts deepgram_output
