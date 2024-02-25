#!/usr/bin/env ruby
# frozen_string_literal: true
require "find"
require "parallel"
require_relative "loaders/document"

module Knowlecule
  class Loader
    attr_accessor :files

    def initialize(sources=[])
      sources.each do |source|
        if File.directory?(source)
          Dir.chdir(source) do
            files = `fd -t f -a`.split("\n")
            files_with_index = Knowlecule::ArrayLib.to_indices_hash(files)
            total_files = files_with_index.count
            Parallel.map(files_with_index, progress: "Adding #{total_files} Files to Database", in_processes: 4) do |f|
              file = Item.info(f[1])
              add(file)
            end
          end
        elsif File.file?(source)
          add(file)
        else
          puts "neither file nor directory, exiting"
        end
      end

    end

    private

    def add(file)
      begin
        Item.create(
          path: file[:path],
          filename: file[:name],
          extension: file[:extension],
          type: file[:mimetype]
        )
      rescue Ohm::UniqueIndexViolation => e
        logger.warn "<#{@path}> already exists in database\n#{e.message}"
      end
    end

  end
end
