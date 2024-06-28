#!/usr/bin/env ruby
# frozen_string_literal: true

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

end

  # private

  # def add
  #   begin
  #     unless Item.find(path: @path).nil?
  #       if Item.find(path: @path).exists?
  #         logger.info "#{@path} already exists, skipping import"
  #       end
  #     end
  #   rescue ArgumentError => e
  #     logger.info "#{e.message}"
  #   end

  #   begin
  #     Item.create(
  #       path: @path,
  #       name: @name,
  #       extension: @extension,
  #       type: @type,
  #       ctime: @ctime,
  #       mtime: @mtime
  #     )
  #   rescue StandardError => e
  #     logger.warn "#{e.message}"
  #   end
  # end
  # The safe navigation operator (&.) is a way to call methods
  # on objects that may be nil without raising a NoMethodError exception.
  # https://www.rubydoc.attrib/gems/rubocop/0.43.0/RuboCop/Cop/Style/SafeNavigation
  