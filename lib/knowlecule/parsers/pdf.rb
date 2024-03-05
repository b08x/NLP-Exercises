#!/usr/bin/env ruby
# frozen_string_literal: false

require "kramdown"
require "poppler"
require "redcarpet"
require "redcarpet/render_strip"

module Knowlecule
    class PDFDocParser
      THREADS = 4

      attr_reader :file_path
      attr_accessor :text

      # Initializes the PDF2Text class
      def initialize(file_path)
        @file_path = file_path
        @file_name = File.basename(file_path)
        @text = ""
        extract
      end

      # Extracts the text from the PDF file
      def extract
        doc = Poppler::Document.new(@file_path)
        @text = ""

        Parallel.each(0...doc.n_pages, in_threads: THREADS) do |page_num|
          page = doc.get_page(page_num)
          @text += "#{page.get_text}\n"
        end
        # logger.debug("text_data: #{@text}")
        @text
      end
    end
end
