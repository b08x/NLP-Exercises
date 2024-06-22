#!/usr/bin/env ruby

# require_relative 'pipeline/text/graph'
require_relative 'pipeline/segment_tokenize'
# require_relative 'pipeline/feature_extraction'
require_relative 'pipeline/hypernyms'
require_relative 'pipeline/lda@modeler'

require 'lingua'

module Text
  include Logging

  module_function

  def sanatize(text)
    clean_text = text.gsub(/\r/,' ').gsub(/\n/,' ').gsub(/\s+/,' ')
    clean_text.gsub!("\t\r ", '')
    clean_text.gsub!('-­‐', '-')
    clean_text.gsub!("•", '')
    clean_text.gsub!("●", '')
    clean_text.gsub!("\n\n", '#keep#')
    clean_text.gsub!("\n", ' ')
    # Fix for an incompatible space character.
    clean_text.gsub!(" ", ' ')
    clean_text.gsub!('#keep#', "\n\n")
    clean_text.gsub!("   ",' ')
    return clean_text
  end

end


#content = Lingua::EN::Readability.new(text)

#content.paragraphs.each {|x| p x; puts "\n\n"}

# p content
#p content.paragraphs
#p content.sentences
# p content.words
# p content.unique_words
# p content.report

# content.sentences.each do |sentence|
#   begin
#     s = sentence.gsub(/^\\|"|^\s/,"").chomp.strip.dup
#     p Knowlecule::Pipeline::Chunker.perform(s)

#   rescue FrozenError => e
#     p e
#   end
# end

require 'linguistics'
require 'pragmatic_tokenizer'
require 'tomoto'

module Punctuation
  def punctuate(text)
    raise NotImplementedError
  end
end

class Punctuator
  include Punctuation

  include Linguistics::EN

  attr_accessor :text

  def initialize(text)
    @text = text
  end

  # def punctuate(text)
  # end
end

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




module Tokenization
  def tokenize(text)
    raise NotImplementedError
  end
end

class Tokenizer
  include Tokenization

  def self.tokenize(text)
    tokenizer = PragmaticTokenizer::Tokenizer.new
    tokenizer.tokenize(text)
  end
end






module TopicModeling
  def generate_topics(tokens)
    raise NotImplementedError
  end
end

class Modeler
  include TopicModeling

  attr_accessor :model, :save_path

  def initialize(save_path)
    @model = Tomoto::LDA.new(k: 10, alpha: 0.1, eta: 0.01, min_cf: 0.1, rm_top: 4, seed: 42)
    @save_path = Pathname.new(save_path).cleanpath
  end

  def generate_topics(tokens)
    @model.add_doc(tokens)
    @model.train(0)
    puts "Num docs: #{@model.num_docs}, Vocab size: #{@model.used_vocabs.length}, Num words: #{@model.num_words}"
    puts "Removed top words: #{@model.removed_top_words}"
    puts "Training..."
    100.times do |i|
      @model.train(10)
      puts "Iteration: #{i * 10}\tLog-likelihood: #{@model.ll_per_word}"
    end

    puts @model.summary
    puts "Saving..."
    @model.save(save_path)

  end
end



#
#
#
# class Topic < ComposableOperations::ComposedOperation
#   use Modeler
# end
#
# topics = Topic.perform(tokenized_sentences)
#
# p topics

# seg = Knowlecule::Pipeline::Segmenter.new(content.paragraphs).perform
#
# seg.segment.each do |t|
#   tokenize = Knowlecule::Pipeline::Tokenizer.new(t).perform
#   p tokenize
#   puts "-------"
#   puts "\n"
# end
