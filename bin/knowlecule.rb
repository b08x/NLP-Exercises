#!/usr/bin/env ruby
# frozen_string_literal: true

lib_dir = File.expand_path(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require "tty-cursor"

require "composable_operations"
require "net/http"
require "dry/monads"

require 'pathname'
require "faraday"
require "hashie"
require "json"
require "jsonl"
require "langchainrb"

require "dotenv"
Dotenv.load(File.join(__dir__, "..", "docker", ".env"))

require "utils/logging"
require "version"
require "config"

require "ui"

require "utils/arraylib"
require "utils/command"
require "utils/glob"
require "utils/linked-list"
require "utils/text/fix_encoding"
# require "utils/text/acronym_finder"
# require "utils/text/normalize_pathnames"

require "db/ohm"
require "db/postgres"

#Knowlecule::Redis.flush
Knowlecule::Redis.connect(ENV['REDIS'])

# require "llm/dify"
# require "llm/huggingface"
require "llm/localai"
require "llm/ollama"

require "item"
# require "deepgram"
require "parser"
require "parsers/ansible"
require "parsers/git"
require "parsers/md"
require "parsers/pdf"
require "parsers/ruby"
require "parsers/srt"
require "parsers/jsonl"
require "pipeline"

require "loader"

# require "menu"
require "cli"

if ARGV.any?
  Drydock.run!(ARGV, $stdin) if Drydock.run? && !Drydock.has_run?
end

p @files

#
# unless ARGV[0].nil?
#   source = ARGV[0]
# end
#
# puts TTY::Cursor.clear_screen
#
# # source = Knowlecule::Util::Glob.documents()
#
# # p file = Item.new(File.new(source))
#
# class FileProcessor
#   def initialize
#     @file_type = nil
#     @action = nil
#   end
#
#   def greet
#       center_cursor
#       greeting_text = `gum style --padding "1" --border double --align center --height=#{(TTY::Screen.height / 8)} --width 0 "Welcome to the File Processor!"`.chomp
#       puts greeting_text
#       sleep 3
#       puts TTY::Cursor.clear_screen
#     end
#
#   def select_file_type
#     @file_type = `gum choose "Video" "Audio" "Text"`.chomp
#   end
#
#   def select_action
#     @action = `gum choose "Process" "Transcribe" "Assess"`.chomp
#   end
#
#   def display_selection
#       file_box = `gum style --padding=1 --border=double --align=center "#{@file_type}"`.chomp
#       action_box = `gum style --padding=1 --border=double --align=center "#{@action}"`.chomp
#
#       joined_output = `gum join --vertical "#{file_box}" "#{action_box}"`
#
#       puts joined_output
#     end
#
#   def execute_action
#     case @action
#     when "Process"
#       process_file
#     when "Transcribe"
#       transcribe_file
#     when "Assess"
#       assess_file
#     else
#       puts "Invalid action selected."
#     end
#   end
#
#   private
#
#   def center_cursor
#     screen_height = TTY::Screen.height
#     screen_width = (TTY::Screen.width / 1.25).round
#     system("tput cup #{screen_height / 2} #{screen_width / 2}")
#   end
#
#   def process_file
#     puts "Processing #{@file_type} file..."
#     # Implement file processing logic here
#   end
#
#   def transcribe_file
#     puts "Transcribing #{@file_type} file..."
#     # Implement file transcription logic here
#   end
#
#   def assess_file
#     puts "Assessing #{@file_type} file..."
#     # Implement file assessment logic here
#   end
# end
#
# # Create an instance of the FileProcessor
# processor = FileProcessor.new
#
# # Run the program
# processor.greet
# processor.select_file_type
# processor.select_action
# processor.display_selection
# processor.execute_action
