#!/usr/bin/env ruby

# require_relative 'pipeline/text/graph'
require_relative 'pipeline/segment_tokenize'
require_relative 'pipeline/feature_extraction'
require_relative 'pipeline/hypernyms'
require_relative 'pipeline/ldamodeler'

require 'lingua'


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
