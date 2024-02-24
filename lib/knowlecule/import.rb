#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  class Import

    def initialize(sources=[])
      files = []
      sources.each do |source|
        if File.directory?(source)
          files += Glob::documents(source)
        elsif File.file?(source)
          files << source
        else
          puts "neither file nor directory, exiting"
        end
      end
        @files = files.map { |file| Knowlecule::Item.new(file) }
    
    start
    end

    private
    def start
      @files.each do |file|
        p file
      end
    end
  end
end