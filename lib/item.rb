#!/usr/bin/env ruby
# frozen_string_literal: true

class Item
  attr_reader :path, :extension, :name, :type, :ctime, :mtime, :media_type
  

  def initialize(source)
    @path = Pathname.new(source).cleanpath.to_s
    @extension = File.extname(source)
    @name = File.basename(source, ".").gsub(@extension, "")
    @type = mime
    @ctime = File.stat(source).ctime
    @mtime = File.stat(source).mtime
    @media_type = determine_media_type
  end

  private
  # The safe navigation operator (&.) is a way to call methods
  # on objects that may be nil without raising a NoMethodError exception.
  # https://www.rubydoc.attrib/gems/rubocop/0.43.0/RuboCop/Cop/Style/SafeNavigation
  def mime
    mime = MimeMagic.by_magic(File.open(@path))
    mime&.type # unless mime.nil?
  rescue NoMethodError
    MimeMagic.by_path(File.open(@path)).type
  end
  
  def determine_media_type
    case @type
    when /text/
      :textual
    when /audio/
      :audio
    when /video/
      :video
    else
      :other
    end
  end
end
