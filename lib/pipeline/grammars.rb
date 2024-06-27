#!/usr/bin/env ruby
# frozen_string_literal: true

require 'linguistics'

module Grammars
  def punctuate(text)
    raise NotImplementedError
  end
end

class Grammar
  include Grammars

  include Linguistics

  attr_accessor :text, :object

  def initialize(text)
    Linguistics.use(:en)
    @text = text
  end

  def synset(word, pos)
    "#{word}".en.synset( pos.to_sym )
  end

  def direct_object(sentence)
    @object = {
      setence: "#{sentence}",
      obj: "#{sentence}".en.sentence.object.to_s
      }
    return @object.to_json
  end

  # def punctuate(text)
  # end
end
