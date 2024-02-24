#!/usr/bin/env ruby
# frozen_string_literal: false

require "mimemagic"

module Knowlecule
  class Item

    attr_accessor :path, :name, :extension, :type

    def initialize(file)
      @path = Pathname.new(file).cleanpath.to_s
      @extension = File.extname(file)
      @name = File.basename(file, ".").gsub(@extension, "")
      mime
    end

    private

    def mime
      begin
        mime = MimeMagic.by_magic(File.open(@path))
        @type = mime.type unless mime.nil?
      rescue NoMethodError
        @type = MimeMagic.by_path(File.open(@path)).type
      end
    end

  end
end