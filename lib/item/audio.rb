#!/usr/bin/env ruby
# frozen_string_literal: true
class Audiofile < Ohm::Model
  include Logging

  extend Dry::Monads[:maybe]

  include Ohm::Callbacks

  attribute :title

  # so, the audio is processed by the language model(s)
  # which will return a the same structure
  # as a document
  # audio will use sonic-annotator
end
