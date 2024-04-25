#!/usr/bin/env ruby
# frozen_string_literal: true
class Image < Ohm::Model
  include Logging

  extend Dry::Monads[:maybe]

  include Ohm::Callbacks

  attribute :title

  # so, the image is processed by the language model
  # which will return a the same structure
  # as a document
  # images will use llava
end
