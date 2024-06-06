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
        @text += "#{line.text.join(' ')}\n"
      end
      @text
    end

    def webvtt
      @vtt.cues.each do |cue|
        @text += "#{cue.text}\n"
      end
      @text
    end

    def convert
      case @item.extension
      when ".srt"
        @vtt = WebVTT.convert_from_srt("#{@path.cleanpath}",
      "#{File.join(@path.dirname.to_s, @path.basename.to_s.gsub(/srt/, 'vtt'))}")
        puts "srt converted to vtt - filed place in #{@path.basename}"
      when ".vtt"
        puts "todo!"
      end

    end

  end
end

file = Item.new('/home/b08x/Recordings/video/2024-05-24_15-28-43.srt')
sub = Knowlecule::ParseSubtitle.new(file)

 puts sub.srt


