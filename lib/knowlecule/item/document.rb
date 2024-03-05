#!/usr/bin/env ruby
# frozen_string_literal: true

class Document < Ohm::Model
  include Logging

  extend Dry::Monads[:maybe]

  include Ohm::Callbacks
  # include Ohm::Scope
  attribute :title
  attribute :content
  attribute :summary

  reference :item, :Item
  reference :subject, :Subject

  #TODO: not sure if this should be a collection or list
  list :sections, :Section

  list :embeddings, :Embedding

  index :title
  index :content
  index :summary

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

  # def extract_text(path, type)
  #   case type
  #   when "application/pdf"
  #     Knowlecule::Extract::PDF.new(path).text
  #   when "text/markdown"
  #     Knowlecule::Extract::Markdown.new(path).text
  #   else
  #     begin
  #       # TODO: this will sometimes return a TrueClass
  #       # will need to refresh on langchainrb
  #       # Langchain::Loader.load(path).value
  #       logger.warn("placeholder message for Langchain::Loader function")
  #     rescue Langchain::Loader::UnknownFormatError => e
  #       logger.warn("#{e.message}")
  #     end
  #
  #   end
  # end

  def before_create
    self.processed = "false"
  end

  def processed!
    self.processed = "true"
    save
  end
end
