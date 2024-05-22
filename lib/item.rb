#!/usr/bin/env ruby
# frozen_string_literal: true

class Item < Ohm::Model
  attr_accessor :stats
  attr_reader :source

  attribute :path
  attribute :name
  attribute :type # image, text, video, audio, multi
  attribute :extension  
  attribute :ctime
  attribute :mtime

  index :path
  index :name
  index :extension
  index :type

  def initialize(source)
    @source = source
    stats
  end

  
  
  def stats
    @stats = {}
    @stats[:path] = Pathname.new(source).cleanpath.to_s
    @stats[:extension] = File.extname(source)
    @stats[:name] = File.basename(source, ".").gsub(@stats[:extension], "")
    @stats[:type] = mime(@stats[:path])
    @stats[:ctime] = File.stat(source).ctime
    @stats[:mtime] = File.stat(source).mtime
    @stats
  end

  # The safe navigation operator (&.) is a way to call methods
  # on objects that may be nil without raising a NoMethodError exception.
  # https://www.rubydoc.attrib/gems/rubocop/0.43.0/RuboCop/Cop/Style/SafeNavigation
  def mime(file)
    mime = MimeMagic.by_magic(File.open(file))
    mime&.type # unless mime.nil?
  rescue NoMethodError
    MimeMagic.by_path(File.open(file)).type
  end
end
