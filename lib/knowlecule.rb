#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

def progname = "knowlecule"

module Knowlecule
  VERSION = "0.1.0"
end

TMPFS = File.join("/tmp/knowlecule")

# require "aoororachain"
require "dry/monads"
require "composable_operations"
require "dotenv"
require "faraday"
require "hashie"
require "json"
require "jsonl"
require "langchainrb"
require "net/http"

require "mercenary"
require "highline/import"

Dotenv.load(File.join(__dir__, "..", ".env"))

require "knowlecule/config"

require "knowlecule/utils/arraylib"
require "knowlecule/utils/glob"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/logging"
require "knowlecule/utils/text/fix_encoding"
# require "knowlecule/utils/text/acronym_finder"
# require "knowlecule/utils/text/normalize_pathnames"

require "knowlecule/database/ohm"
require "knowlecule/database/postgres"

require "knowlecule/llm/flowise"
require "knowlecule/llm/huggingface"
require "knowlecule/llm/localai"
require "knowlecule/llm/ollama"

# require "knowlecule/pipeline/loaders/text"
# require "knowlecule/pipeline/loaders/audio"
# require "knowlecule/pipeline/loaders/video"

require "knowlecule/pipeline/parsers/ansible"
require "knowlecule/pipeline/parsers/git"
require "knowlecule/pipeline/parsers/md"
require "knowlecule/pipeline/parsers/pdf"
require "knowlecule/pipeline/parsers/ruby"

require "knowlecule/import"
require "knowlecule/pipeline"

# module Knowlecule
#   autoload :CLI, "cli"
#   class Options
#     attr_accessor :import
#     def initialize
#       @import = []

#     end
#   end

# end

puts "hey hey hey"

Mercenary.program(:Knowlecule) do |p|
  p.version Knowlecule::VERSION
  p.description <<~DESC
    An NLP Interface
    by Robert Pannick (rwpannick@gmail.com)

    Check the <location> for project discussion/help: <website>
  DESC
  p.syntax "knowlecule <subcommand> [options]"

  @processing_option = [
    :path,
    "--path FOLDER1 FILE1",
    Array,
    "Loads a file or a folder of files"
  ]

  p.command(:import) do |c|
    c.syntax "import <paths separated by space>"
    c.description "Loads file metadata into redis cache"
    c.option(*@processing_option)
    c.option "files", "-f FILE1[,FILE2[,FILE3...]]", "--files FILE1[,FILE2[,FILE3...]]", Array, "Files to import"
    c.option "process", "-p", "--process", "processes the imported files"

    c.command(:yermom) do |m|
      m.syntax "subcommand to something"
      m.description "alters the command somehow"
      m.option "likes", "-l", "a flag"

      m.action do |args, options|
        puts "#{args}"
        puts "#{options}"
      end
    end

    c.action do |args, options|
      puts "#{args}"
      puts "#{options}"

      args.each do |source|
        unless Dir.exist?(source)
          puts "#{source} path invalid, go fuck yourself"
          exit
        end
        Knowlecule::Import.new(source)
      end
    end
  end
end
