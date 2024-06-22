#!/usr/bin/env ruby
# frozen_string_literal: true

require 'linguistics'

module Punctuation
  def punctuate(text)
    raise NotImplementedError
  end
end

class Punctuator
  include Punctuation

  include Linguistics

  attr_accessor :text

  def initialize(text)
    @text = text
  end

  # def punctuate(text)
  # end
end
