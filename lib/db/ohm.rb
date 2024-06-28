#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mimemagic'
require 'ohm'
require 'ohm/contrib'

# module Knowlecule
#   module Redis
#     module_function
#
#     def connect(host)
#       Ohm.redis = Redic.new(host)
#       puts 'connected to redis host!'
#     rescue Ohm::Error => e
#       puts "Unable to connect to Redis Cache #{e}"
#       exit
#     end
#
#     def flush
#       Ohm.redis.call 'FLUSHDB'
#       puts "Redis Cache Flushed! host: #{ENV.fetch('REDIS')}"
#     end
#   end
# end

Ohm.redis = Redic.new("redis://127.0.0.1:6379")

class Item < Ohm::Model
  include Logging

  extend Dry::Monads[:maybe]

  include Ohm::Callbacks

  attribute :path
  attribute :name
  attribute :extension
  attribute :type
  attribute :ctime
  attribute :mtime

  unique :path

  index :path
  index :name
  index :extension
  index :type

  attr_reader :path, :extension, :name, :type, :ctime, :mtime, :media_type


  def initialize(source)
    @path = Pathname.new(source).cleanpath.to_s
    @extension = File.extname(source)
    @name = File.basename(source, ".").gsub(@extension, "")
    @type = mime
    @ctime = File.stat(source).ctime
    @mtime = File.stat(source).mtime
    @media_type = determine_media_type
    add
  end

  private

  def add
    begin
      unless Item.find(path: @path).nil?
        if Item.find(path: @path).exists?
          logger.info "#{@path} already exists, skipping import"
        end
      end
    rescue ArgumentError => e
      logger.info "#{e.message}"
    end

    begin
      Item.create(
        path: @path,
        name: @name,
        extension: @extension,
        type: @type,
        ctime: @ctime,
        mtime: @mtime
      )
    rescue StandardError => e
      logger.warn "#{e.message}"
    end
  end
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
    if @type.nil?
      case @extension
      when /md|txt|pdf|html|json|jsonl/
        :textual
      when /wav|mp3|ogg|flac|opus/
        :audio
      when /mkv|mp4/
        :video
      else
        :other
      end
    else
      case @type
      when /text|pdf/
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
end



class Subject < Ohm::Model
  attribute :name
  attribute :description
  # attribute :vector

  collection :items, :Item
  collection :documents, :Document
  # collection :sections, :Sections

  unique :name
  index :name
end


# Within a section, you typically find a cohesive group of related content that is organized around a common theme or topic. Sections are commonly used in documents, articles, or books to structure and organize information. They often contain headings, subheadings, paragraphs, lists, tables, or other elements that help to present and explain the context within that section as well as the document as a whole.

class Section < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Callbacks

  attribute :uuid

  # Character position within the source item
  attribute :start_position
  attribute :end_position

  attribute :content
  attribute :summary

  # attribute :headings
  attribute :paragraphs, Type::Array
  attribute :sentences, Type::Array

  attribute :lists # bullet point or number lists, ordered|unordered
  attribute :figures # or :images
  attribute :tables

  list :phrases, :Phrase
  list :words, :Word

  reference :subject, :Subject

  # attribute :embedding, :Embedding

  reference :document, :Document
  reference :subject, :Subject
  reference :item, :Item

  index :content
  index :summary
  index :uuid

  unique :uuid

  def before_create
    self.uuid = SecureRandom.uuid
  end
end

class Phrase < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Callbacks

  attribute :phrase
end

class Word < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Callbacks

  attribute :uuid
  # a term typically refers to a word or phrase that has a specific meaning within a particular context, domain, or subject area
  attribute :term
  attribute :synsets

  # attribute :part_of_speech
  # attribute :named_entity

  reference :paragraph, :Paragraph
  reference :sentence, :Sentence
  reference :section, :Section
  reference :phrase, :Phrase

  reference :document, :Document
  reference :item, :Item

  collection :embedding, :Embedding

  index :word

  unique :uuid
  def before_create
    self.uuid = SecureRandom.uuid
  end
end

# class Token < Ohm::Model
#   include Ohm::DataTypes
#   include Ohm::Callbacks

#   attribute :character

#   reference :word, :Word

#   index :character
# end

# class Embedding < Ohm::Model
#   include Ohm::DataTypes
#   # include Ohm::Callbacks

#   attribute :vector, Type::Array

#   reference :chunk, :Part
#   reference :topic, :Subject

#   # def before_create
#   #   self.id = SecureRandom.uuid
#   # end
# end

# related words to connect to
# class Synsets < Ohm::Model
# end
