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

    # Function to drop the database/tables if a condition is true
    def drop_database
      logger.debug("Dropping database and tables")
      begin
        @db.drop_table?(:items)
        @db.drop_table?(:documents)
        @db.drop_table?(:audiofiles)
        @db.disconnect
        logger.debug("Database and tables dropped successfully")
      rescue StandardError => e
        logger.fatal e.to_s
      end
    end
  end
end

DB = Knowlecule::PG.new.db

logger.debug("Creating tables if they don't already exist")

begin
  DB.create_table? (:items) do
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

  DB.create_table?(:documents) do
    primary_key :id, type: :Bignum
    column :title, String
    column :content, String
    jsonb :metadata
    column :embedding, "vector(1536)"

    foreign_key :item_id, :items
    full_text_index :content
    index %i[metadata embedding]
  end

  DB.create_table?(:audiofiles) do
    primary_key :id, type: :Bignum
    column :title, String
    column :content, String
    jsonb :metadata
    column :embedding, "vector(1536)"

    foreign_key :item_id, :items
    full_text_index :content
    index %i[metadata embedding]
  end

rescue StandardError => e
  logger.fatal e.to_s
end
