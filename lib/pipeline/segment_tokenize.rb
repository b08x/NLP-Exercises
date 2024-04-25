#!/usr/bin/env ruby

require 'lemmatizer'
require 'pragmatic_segmenter'
require 'pragmatic_tokenizer'

TEST = :all

module Knowlecule
  module Pipeline
    class Tokenizer < ComposableOperations::Operation
      processes :text

      property :punct, default: :all, required: true
      property :stopwords, default: false, required: true

      before do
        @options = {
          remove_stop_words: stopwords,
          punctuation: punct,
          numbers: :all,
          minimum_length: 0,
          remove_emoji: true,
          remove_emails: true,
          remove_urls: true,
          remove_domains: true,
          expand_contractions: true,
          clean: false,
          mentions: :keep_original,
          hashtags: :keep_original,
          classic_filter: true,
          downcase: false,
          long_word_split: 20
        }
      end

      def execute
        begin
          text.segment.map do |segment|
            PragmaticTokenizer::Tokenizer.new(@options).tokenize(segment)
          end
        rescue NoMethodError => e
          p e
        ensure
          PragmaticTokenizer::Tokenizer.new(@options).tokenize(text.text)
        end
      end
    end

    class Segmenter < ComposableOperations::Operation
      processes :text

      def execute
        PragmaticSegmenter::Segmenter.new(text: text)
      end
    end

    class Chunker < ComposableOperations::ComposedOperation
      use Segmenter
      # use Tokenizer, punct: :none, stopwords: true
      use Tokenizer
    end
  end
end


#TODO: syllables
