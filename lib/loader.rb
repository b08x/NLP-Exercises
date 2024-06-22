#!/usr/bin/env ruby
# frozen_string_literal: true

# require "find"
require "parallel"
# require_relative "loaders/document"

module Knowlecule
  class Loader
    attr_accessor :files

    def initialize(source)
      if File.directory?(source)
        Dir.chdir(source) do
          glob = `fd -t f -a`.split("\n")
          files = Knowlecule::ArrayLib.to_indices_hash(glob)
          Parallel.map(files, progress: "     #{files.count}", in_processes: 3) do |file|
            ohm_add(Item.metadata(file[1]))
          end
        end
      elsif File.file?(source)
        ohm_add(Item.metadata(source))
      else
        puts "neither file nor directory, exiting"
      end
    end

    private

    def ohm_add(file)
      logger.debug("adding #{file}")
      Item.create(
        path: file[:path],
        name: file[:name],
        extension: file[:extension],
        type: file[:type],
        ctime: file[:ctime],
        mtime: file[:mtime]
      )
    rescue Ohm::UniqueIndexViolation => e
      logger.warn "<#{@path}> already exists in database\n#{e.message}"
    end
  end
end

# depending on file type ---> return a text object, audio, or video object
