#!/usr/bin/env ruby

require "aoororachain"
require "composable_operations"
require "net/http"
require "dry/monads"

require "faraday"
require "hashie"
require "json"
require "jsonl"
require "langchainrb"

require "dotenv"
Dotenv.load(File.join(__dir__, "..", ".env"))

## Ensure all libs in vendor directory are available
Dir["#{File.expand_path("../vendor", __FILE__)}/*/lib/"].each do |vendor_lib|
  $:.unshift vendor_lib
end

require_relative '../vendor/aia/lib/aia'


require "knowlecule/version"
require "knowlecule/config"

require "knowlecule/ui"

require "knowlecule/utils/arraylib"
require "knowlecule/utils/glob"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/logging"
require "knowlecule/utils/text/fix_encoding"
# require "knowlecule/utils/text/acronym_finder"
# require "knowlecule/utils/text/normalize_pathnames"

require "knowlecule/db/ohm"
require "knowlecule/db/postgres"
require "knowlecule/db/import"

require "knowlecule/llm/flowise"
require "knowlecule/llm/huggingface"
require "knowlecule/llm/localai"
require "knowlecule/llm/ollama"

require "knowlecule/pipeline/pipeline"

require "knowlecule/parsers/ansible"
require "knowlecule/parsers/git"
require "knowlecule/parsers/md"
require "knowlecule/parsers/pdf"
require "knowlecule/parsers/ruby"

# socrates

# betty
