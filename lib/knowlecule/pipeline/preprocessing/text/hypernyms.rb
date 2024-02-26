#!/usr/bin/env ruby
# frozen_string_literal: true

require "wordnet"

class WordSenses < ComposableOperations::ComposedOperation
  processes :word

  before do
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
