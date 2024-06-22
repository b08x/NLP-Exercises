#!/usr/bin/env ruby

require_relative 'deepgram/deepgram'
require_relative 'pipeline/segmentation'
require_relative 'pipeline/tokenization'
require_relative 'pipeline/tagging'
require_relative 'pipeline/modeler'
require_relative 'pipeline/hypernyms'


longtext = Item.new('/home/b08x/Recordings/staging/test0001/2024-05-22_23-13-31_deepgram.json')

@text = Deepgram.new(longtext.path)
@text.parse_json

@extractor = SpacyFeatureExtractor.new
@tt = []

puts Segmenter.segment(@text.transcript).words

puts "------\n"

@text.paragraphs.each do |para|
  @tt << Tokenizer.tokenize(para)
  # p tt.join(" ").strip.chomp
  #puts @extractor.sentences_to_json(para)
end

@tt.each do |t|
  p t.join(" ")
end


# puts @nerds
puts "------\n"

# puts @extractor.deps
#
# module Text
#   include Logging
#
#   module_function
#
#   def sanatize(text)
#     clean_text = text.gsub(/\r/,' ').gsub(/\n/,' ').gsub(/\s+/,' ')
#     clean_text.gsub!("\t\r ", '')
#     clean_text.gsub!('-­‐', '-')
#     clean_text.gsub!("•", '')
#     clean_text.gsub!("●", '')
#     clean_text.gsub!("\n\n", '#keep#')
#     clean_text.gsub!("\n", ' ')
#     # Fix for an incompatible space character.
#     clean_text.gsub!(" ", ' ')
#     clean_text.gsub!('#keep#', "\n\n")
#     clean_text.gsub!("   ",' ')
#     return clean_text
#   end
#
# end


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
# exit

# modeler = Modeler.new(Dir.pwd)
#
# @tt.each do |tokens|
#   modeler.add(tokens)
# end
# modeler.train
# modeler.summary
#
# puts modeler.model.topic_words
#
#
