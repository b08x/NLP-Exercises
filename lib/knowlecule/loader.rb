#!/usr/bin/env ruby
# frozen_string_literal: true
require "find"
require_relative "loaders/document"

module Knowlecule
  class Loader
    attr_accessor :files

    def initialize(sources=[])
      @files = LinkedList.new()
      sources.each do |source|
        if File.directory?(source)
          Find.find(source) do |file|
            next if File.directory?(file)
            @files.push(Knowlecule::Item.new(file))
          end
        elsif File.file?(source)
          @files.push(Knowlecule::Item.new(source))
        else
          puts "neither file nor directory, exiting"
        end
      end

    end

    def import
      @files.length.times do
        file = @files.pop
        p file.type unless file.nil? || file.type.nil?

      end

    end


  end
end
