#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

TMPFS = File.join("/tmp/knowlecule")

require "aoororachain"
require "dotenv"
require "jsonl"
require "faraday"
require "langchainrb"
require "hashie"
require "net/http"
require "json"

Dotenv.load(File.join(__dir__, "..", ".env"))

require "knowlecule/config"

require "knowlecule/utils/arraylib"
require "knowlecule/utils/glob"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/logging"

require "knowlecule/database/ohm"
require "knowlecule/database/postgres"

require "knowlecule/llm/flowise"
require "knowlecule/llm/huggingface"
require "knowlecule/llm/localai"
require "knowlecule/llm/ollama"

require "knowlecule/loader"

require "knowlecule/cli"

module Knowlecule
  autoload :CLI, "knowlecule/cli"
  autoload :VERSION, "knowlecule/version"
end

Aoororachain.logger = Logger.new($stdout)
Aoororachain.log_level = Aoororachain::LEVEL_DEBUG
