#!/usr/bin/env ruby
require 'pathname'
# require 'subtitle'
require 'srt'
require 'webvtt'

module Knowlecule
  class ParseSRT
    attr_reader :path, :source
    attr_accessor :text, :vtt, :srt

    def initialize(file_path)
      @path = Pathname.new(file_path)
      @text = ''
    end

    def srt
      @srt = SRT::File.parse(File.new("#{@path.cleanpath}"))
      @srt.lines.each do |line|
        @text += "#{line.text.join(' ')}\n"
      end
      @text
    end

    def webvtt
      @vtt = WebVTT.convert_from_srt("#{@path.cleanpath}",
                                     "#{File.join(@path.dirname.to_s, @path.basename.to_s.gsub(/srt/, 'vtt'))}")
      @vtt.cues.each do |cue|
        @text += "#{cue.text}\n"
      end
      @text
    end
  end
end

file = Item.new('/home/b08x/Recordings/video/daily_morning_standup.srt')

p file.stats[:path]

# puts file.source
