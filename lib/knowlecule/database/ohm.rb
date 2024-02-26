#!/usr/bin/env ruby
# frozen_string_literal: true

require "mimemagic"
require "ohm"
require "ohm/contrib"

begin
  Ohm.redis = Redic.new(ENV["REDIS"])
  # Ohm.redis.call "FLUSHDB"
  # exit
rescue Ohm::Error => e
  logger.fatal e.to_s
  exit
end

class Item < Ohm::Model
  attr_accessor :path, :name, :extension, :type

  attribute :path
  attribute :filename
  attribute :extension
  attribute :type # image, text, video, audio, multi

  collection :documents, :Document

  index :path
  index :filename
  index :extension
  index :type

  def self.metadata(file)
    info = {}
    info[:path] = Pathname.new(file).cleanpath.to_s
    info[:extension] = File.extname(file)
    info[:name] = File.basename(file, ".").gsub(info[:extension], "")
    info[:mimetype] = mime(info[:path])
    return info
  end
# The safe navigation operator (&.) is a way to call methods
# on objects that may be nil without raising a NoMethodError exception.
# https://www.rubydoc.info/gems/rubocop/0.43.0/RuboCop/Cop/Style/SafeNavigation
  def self.mime(file)
    begin
      mime = MimeMagic.by_magic(File.open(file))
      mime&.type # unless mime.nil?
    rescue NoMethodError
      MimeMagic.by_path(File.open(file)).type
    end
  end
end

class Topic < Ohm::Model
  attribute :name
  attribute :description
  attribute :vector

  collection :documents, :Document
  collection :chunks, :Chunk

  unique :name
  index :name
end

class Document < Ohm::Model
  include Logging

  extend Dry::Monads[:maybe]

  include Ohm::Callbacks
  # include Ohm::Scope
  attribute :title
  attribute :content

  reference :items, :Item

  collection :topics, :Topic

  list :chunks, :Chunk

  index :title
  index :content

  # scope do
  #   def pending
  #     find(processed: "false")
  #   end
  # end

  def self.call(path:)
    result = find_document(path)
  end

  def self.find_document(path)
    Maybe(Document.find(path: path).first).to_result(:document_not_found)
  end

  def extract_text(path, type)
    case type
    when "application/pdf"
      Knowlecule::Extract::PDF.new(path).text
    when "text/markdown"
      Knowlecule::Extract::Markdown.new(path).text
    else
      begin
        #TODO: this will sometimes return a TrueClass
        # will need to refresh on langchainrb
        #Langchain::Loader.load(path).value
        logger.warn("placeholder message for Langchain::Loader function")
      rescue Langchain::Loader::UnknownFormatError => e
        logger.warn("#{e.message}")
      end

    end
  end

  def before_create
    self.processed = "false"
  end

  def processed!
    self.processed = "true"
    save
  end

end

class Chunk < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Callbacks

  attribute :uuid
  attribute :text
  attribute :segments, Type::Array
  attribute :tokens, Type::Array
  attribute :dep, Type::Hash
  attribute :ner, Type::Hash
  attribute :summary

  list :words, :Word
  list :embedding, :Embedding

  reference :document, :Document
  reference :topic, :Topic

  index :text
  index :tokens
  index :uuid

  unique :uuid

  def before_create
    self.uuid = SecureRandom.uuid
  end
end

class Word < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Callbacks

  attribute :uuid
  attribute :word
  attribute :synsets, Type::Hash
  # attribute :part_of_speech
  # attribute :named_entity

  reference :chunk, :Chunk
  collection :embedding, :Embedding

  index :word

  unique :uuid
  def before_create
    self.uuid = SecureRandom.uuid
  end
end

class Embedding < Ohm::Model
  include Ohm::DataTypes
  # include Ohm::Callbacks

  attribute :vector, Type::Array

  reference :chunk, :Chunk
  reference :topic, :Topic

  # def before_create
  #   self.id = SecureRandom.uuid
  # end
end
