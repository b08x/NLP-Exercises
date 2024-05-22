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
require "pipeline"

require "loader"


case ARGV[0]
when "parse"
  puts "heyo"
end

