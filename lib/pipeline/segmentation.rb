#!/usr/bin/env ruby
# frozen_string_literal: true

require 'lingua'


module Segmentation
  def segment(text)
    raise NotImplementedError
  end
end

class Segmenter
  include Segmentation

  def self.segment(text)
    content = Lingua::EN::Readability.new(text)
    content
  end
end