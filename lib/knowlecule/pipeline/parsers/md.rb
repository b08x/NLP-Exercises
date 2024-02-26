#!/usr/bin/env ruby
# frozen_string_literal: false

require "beckett"
require "kramdown"
require "redcarpet"
require "redcarpet/render_strip"

module Knowlecule
  module Extract
    class Markdown
      attr_reader :file_path
      attr_accessor :text

      def initialize(file_path)
        @file_path = file_path
        @file_name = File.basename(file_path)
        @text = ""
        extract
      end

      def extract
        text = Kramdown::Document.new(File.read(@file_path)).to_s
        to_json(text)
      end

      private

      def to_json(*_args)
        @text = Beckett::Document.new(text).to_json
      end
    end
  end
end
