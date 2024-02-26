#!/usr/bin/env ruby
# frozen_string_literal: true

# require "find"
require "parallel"
# require_relative "loaders/document"

module Knowlecule
  class Import
    attr_accessor :files

    def initialize(source)
      if File.directory?(source)
        Dir.chdir(source) do
          glob = `fd -t f -a`.split("\n")
          files = Knowlecule::ArrayLib.to_indices_hash(glob)
          Parallel.map(files, progress: "     #{files.count}", in_processes: 3) do |file|
            add(Item.metadata(file[1]))
          end
        end
      elsif File.file?(source)
        add(file)
      else
        puts "neither file nor directory, exiting"
      end
    end

    private

    def add(file)
      logger.debug("adding #{file}")
      Item.create(
        path: file[:path],
        filename: file[:name],
        extension: file[:extension],
        type: file[:mimetype],
        ctime: file[:ctime],
        mtime: file[:mtime]
      )
    rescue Ohm::UniqueIndexViolation => e
      logger.warn "<#{@path}> already exists in database\n#{e.message}"
    end
  end
end
