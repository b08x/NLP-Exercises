#!/usr/bin/env ruby
require 'pathname'
# require 'subtitle'
require 'srt'
require 'webvtt'

module Knowlecule
  class ParseSubtitle
    attr_reader :path, :source
    attr_accessor :text, :vtt, :srt

    def initialize(item)
      @item = item
      @path = Pathname.new(item.path)
      @text = ''
    end

    def srt
      @srt = SRT::File.parse(File.new("#{@path.cleanpath}"))
      @srt.lines.each do |line|
        # Extract the text after the last newline
        text_part = line.text.join(' ').split("\n").last
        # Skip lines with timestamps
        if text_part && text_part.match?(/<[^>]+>/)
          next
        end
        @text += "#{text_part}\n"
      end
      @text
    end

    def webvtt
      @vtt = WebVTT::File.new("#{@path.cleanpath}")
      seen_lines = []
      @vtt.cues.each do |cue|
        line = cue.text
        unless seen_lines.include?(line)
          # Extract the text after the last newline
          text_part = line.split("\n").last
          # Skip lines with timestamps
          if text_part && text_part.match?(/<[^>]+>/)
            next
          end
          @text += "#{text_part}\n"
          seen_lines << line
        end
      end
      @text
    end

    def convert
      case @item.extension
      when '.srt'
        @vtt = WebVTT.convert_from_srt("#{@path.cleanpath}",
                                       "#{File.join(@path.dirname.to_s, @path.basename.to_s.gsub(/srt/, 'vtt'))}")
        puts "srt converted to vtt - filed place in #{@path.basename}"
      when '.vtt'
        puts 'todo!'
      end
    end
  end
end

# file = Item.new('/tmp/a_concept_loop.en.vtt')
