#!/usr/bin/env ruby
# frozen_string_literal: true

class Item < Ohm::Model
  attr_accessor :path, :name, :extension, :type, :mtime

  attribute :path
  attribute :name
  attribute :type # image, text, video, audio, multi
  attribute :extension  
  attribute :ctime
  attribute :mtime

  index :path
  index :filename
  index :extension
  index :type

  def self.metadata(file)
    info = {}
    info[:path] = Pathname.new(file).cleanpath.to_s
    info[:extension] = File.extname(file)
    info[:name] = File.basename(file, ".").gsub(info[:extension], "")
    info[:type] = mime(info[:path])
    info[:ctime] = File.stat(file).ctime
    info[:mtime] = File.stat(file).mtime
    info
  end

  # The safe navigation operator (&.) is a way to call methods
  # on objects that may be nil without raising a NoMethodError exception.
  # https://www.rubydoc.info/gems/rubocop/0.43.0/RuboCop/Cop/Style/SafeNavigation
  def self.mime(file)
    mime = MimeMagic.by_magic(File.open(file))
    mime&.type # unless mime.nil?
  rescue NoMethodError
    MimeMagic.by_path(File.open(file)).type
  end
end
