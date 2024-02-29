#!/usr/bin/env ruby

# require "aoororachain"
require "composable_operations"

require "dry/monads"
require "faraday"
require "hashie"
require "json"
require "jsonl"
require "langchainrb"
require "net/http"


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




# module Knowlecule
#   autoload :CLI, "cli"
#   class Options
#     attr_accessor :import
#     def initialize
#       @import = []

#     end
#   end

# end

CLI::UI.frame_style = :box

CLI::UI::StdoutRouter.enable

CLI::UI::Frame.open("{{Knowlecule}} {{bold:a}}", color: :green) do

  Mercenary.program(:Knowlecule) do |p|
    p.version Knowlecule::VERSION
    p.description <<~DESC
      An NLP Interface
      by Robert Pannick (rwpannick@gmail.com)

      Check the <location> for project discussion/help: <website>
    DESC
    p.syntax "knowlecule <subcommand> [options]"

    p.command(:redis) do |c|
      c.syntax "redis <flush>"
      c.description "flush the redis cache"
      c.option "flush", "-f", "--flush", "flush the redis cache"
      c.action do |_args, options|
        Knowlecule::DB::Redis.flush if options["flush"]
      end
    end

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

      c.action do |args, _options|
        CLI::UI::Frame.open("Import") do
          args.each do |source|
            unless Dir.exist?(source)
              CLI::UI::Frame.divider("{{x}} error error error", color: :red)
              puts CLI::UI.fmt "{{info:source}} {{red:#{source} does not exist}}"
              # logger.fatal("#{source} path invalid")
              exit
            end
            puts CLI::UI.fmt "{{info:importing files from}} {{green:#{source}}}"
            Knowlecule::Import.new(source)
          end
        end
      end
    end
  end
end

# CLI::UI::Spinner.spin("this:") do |spinner|
#   sleep 10
#   spinner.update_title("kitty")
#   `kitty`
#   spinner.update_title("something")
#   sleep 1
#   puts "thing 2"
#   spinner.update_title("something else")
#   sleep 1
# end
