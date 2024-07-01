#!/usr/bin/env ruby
# frozen_string_literal: true


require "wordnet"

class RelatedWords
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


class WordSenses

  def initialize
    @lexicon = WordNet::Lexicon.new
  end

  def hypernyms
    @origins.each_with_index do |syn, _idx|
      @hypernyms = []
      # Traverse the hypernyms
      syn.traverse(:hypernyms).with_depth.each do |hyper_syn, depth|
        indent = "  " * depth
        @hypernyms << format("%s%s", indent, hyper_syn)
      end
      puts "Tree has #{@hypernyms.length} synsets."
    end
    @hypernyms
  end

  def execute
    @origins = @lexicon.lookup_synsets(word, :noun)
    hypernyms
  end
end
