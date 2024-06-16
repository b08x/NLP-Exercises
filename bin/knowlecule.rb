#!/usr/bin/env ruby
# frozen_string_literal: true

lib_dir = File.expand_path(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

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

Knowlecule::Redis.connect(ENV['REDIS'])

# require "llm/dify"
# require "llm/huggingface"
require "llm/localai"
require "llm/ollama"

require "item"
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


unless ARGV[0].nil?

  source = ARGV[1]

file = Item.new(File.new(source))

case ARGV[0]

when "subs"
  sub = Knowlecule::ParseSubtitle.new(file)
  puts sub.convert
when "jsonl"
  chat = Knowlecule::ParseJSONL.parse(file)
  puts chat.jsonl
end

end