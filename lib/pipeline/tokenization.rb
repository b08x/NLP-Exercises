#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pragmatic_tokenizer'


module Tokenization
  def tokenize(text)
    raise NotImplementedError
  end
end

class Tokenizer
  include Tokenization

  def self.tokenize(text)
    options = {
      # remove_stop_words: stopwords,
      # punctuation: punct,
      numbers: :all,
      minimum_length: 0,
      remove_emoji: false,
      remove_emails: true,
      remove_urls: true,
      remove_domains: true,
      expand_contractions: true,
      clean: true,
      mentions: :keep_original,
      hashtags: :keep_original,
      classic_filter: true,
      downcase: false,
      long_word_split: 20
    }
    tokenizer = PragmaticTokenizer::Tokenizer.new(options)
    tokenizer.tokenize(text)
  end
end
