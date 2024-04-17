#!/usr/bin/env ruby

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
# Dir["#{File.expand_path("../../vendor", __FILE__)}/*/lib/"].each do |vendor_lib|
#   $:.unshift vendor_lib
# end

require "knowlecule/utils/logging"

require "knowlecule/version"
require "knowlecule/config"

require "knowlecule/ui"

require "knowlecule/utils/arraylib"
require "knowlecule/utils/glob"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/text/fix_encoding"
# require "knowlecule/utils/text/acronym_finder"
# require "knowlecule/utils/text/normalize_pathnames"

require "knowlecule/db/ohm"
require "knowlecule/db/postgres"

Knowlecule::Redis.connect(ENV['REDIS'])

require "knowlecule/llm/flowise"
require "knowlecule/llm/huggingface"
require "knowlecule/llm/localai"
require "knowlecule/llm/ollama"

require "knowlecule/item"
require "knowlecule/parser"
require "knowlecule/pipeline/pipeline"

require "knowlecule/loader"

# folder = prompt.ask("Folder name? Assuming folder is in #{LIBRARY}/") do |q|
#   q.required(true)
#   q.validate ->(v) {return Dir.exist?(File.join(LIBRARY, v)) }
#   q.messages[:valid?] = 'Folder does not exist'
#   q.messages[:required?] = 'Folder name must not be empty'
# end


# puts "Menu:"
# puts "1: Import"
# puts "2: Export"
# puts "3: Query"
# puts "4: Delete"
# puts "5: Update"
# puts "6: List items"
# puts "7: Clear cache"
# puts "0: Exit"

# option = prompt.ask("Select an option (1-7) or 0 to exit?" do |q|
#   q.required(true)
# end

# case option
# when '1'
#   # Import code here
# when '2'
#   # Export code here
# when '3'
#   # Query code here
# when '4'
#   # Delete code here
# when '5'
#   # Update code here
# when '6'
#   # List items code here
# when '7'
#   # Clear cache code here
# when '0'
#   exit
# else
#   puts "Invalid option."
# end



# socrates

# betty
