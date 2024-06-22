#!/usr/bin/env ruby
# frozen_string_literal: true

require "pgvector"
require "sequel"
require "securerandom"

include Logging

logger.debug("Connecting to postgresql database")

module Knowlecule
  class PG

    attr_accessor :db

    def initialize
      begin
        @db = Sequel.connect(ENV['POSTGRES'])

        @db.run("CREATE EXTENSION IF NOT EXISTS vector")
        @db.run("CREATE EXTENSION IF NOT EXISTS hstore")

        @db.extension :pg_array, :pg_hstore
        @db.extension :pg_json
        @db.wrap_json_primitives = true

        logger.debug("Connected to pg")

      rescue StandardError => e
        logger.fatal e.to_s
      end

    end
  end
end

@db = Knowlecule::PG.new.db

logger.debug("Creating tables if they don't already exist")

begin
  @db.create_table? (:items) do
    primary_key :id, type: :Bignum
    column :path, String, unique: true
    column :filename, String
    column :extension, String
    column :type, String
    column :size, Integer
    column :mtime, Integer
    column :ctime, Integer
    index %i[path filename extension type] # %i creates an array of symbols
  end

  @db.create_table? :subjects do
    primary_key :id, type: :Bignum
    column :name, String
    column :description, :text
    column :embedding, "vector(1536)"
    index :name, unique: true
  end

  @db.create_table?(:documents) do
    primary_key :id, type: :Bignum
    column :title, String
    column :content, String
    jsonb :metadata
    column :embedding, "vector(1536)"

    foreign_key :topic_id, :topics
    full_text_index :content
    index %i[metadata embedding]
  end

  @db.create_table?(:audiofiles) do
    primary_key :id, type: :Bignum
    column :title, String
    column :content, String
    jsonb :metadata
    column :embedding, "vector(1536)"

    foreign_key :topic_id, :topics
    full_text_index :content
    index %i[metadata embedding]
  end

  @db.create_table?(:sections) do
    primary_key :id, type: :Bignum
    column :text, String
    jsonb :tokenized_text
    jsonb :sanitized_text
    foreign_key :document_id, :documents
    index %i[text document_id]
  end

  @db.create_table?(:words) do
    primary_key :id, type: :Bignum
    column :word, String
    column :synsets, "json"
    column :part_of_speech, String
    column :named_entity, String
    foreign_key :chunk_id, :parts
    index %i[word chunk_id]
  end

  @db.create_table?(:embeddings) do
    primary_key :id, type: :Bignum
    column :vector, "vector(1536)"
    foreign_key :chunk_id, :parts
    foreign_key :topic_id, :topics
    index %i[vector chunk_id topic_id]
  end
rescue StandardError => e
  logger.fatal e.to_s
end
