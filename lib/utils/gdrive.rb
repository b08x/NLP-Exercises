#!/usr/bin/env ruby
# frozen_string_literal: true

require "google_drive"
require "timeout"

module Knowlecule
  class CloudStorage
    def initialize
      @session = GoogleDrive::Session.from_config("config.json")
    end

    def upload(path)
      @session.upload_from_file(path, filename, convert: false)
    end

    def file(id)
      @session.file_by_id(id)
    rescue Google::Apis::ClientError => e
      raise "File #{id} not found" if e.status == 404

      raise e
    end

    def create_collection(title)
      timeout(10) { @session.create_collection(title) }
    rescue Timeout::Error
      raise "Could not create collection \"#{title}\""
    end

    def create_file(title, content)
      timeout(10) { @session.create_file(title, content) }
    rescue Timeout::Error
      raise "Could not create file \"#{title}\""
    end

    def create_folder(title)
      timeout(10) { @session.create_folder(title) }
    rescue Timeout::Error
      raise "Could not create folder \"#{title}\""
    end

    def files(query, fields)
      @session.files(query: query, fields: fields)
    end
  end
end
