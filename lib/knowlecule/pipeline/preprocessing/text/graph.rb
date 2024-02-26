#!/usr/bin/env ruby
# frozen_string_literal: true

require 'networkx'

@graph = NetworkX::Graph.new

tokenized_sentences.map! { |chunk| DependencyParse.perform(chunk) }

tokenized_sentences.each do |words|
  puts "--------------------------"
  puts "\n\n"
  puts "parsing #{words}...."

  words.each do |w|

    puts "word: #{w}\n"

    word = w.keys[0]

    partofspeech = w.values[0][:pos]

    puts "POS: #{partofspeech}"

    #next unless partofspeech == :noun

    if partofspeech.to_s =~ /nn|nnp/
      @graph.add_node(word)

      # lemma = Lemma.perform(w.downcase)
      lemma = w.values[0][:lemma]

      puts "lemma: #{lemma}"

      hypernyms = WordSenses.perform(word)

      next if hypernyms.nil?

      # p hypernyms

      hypernyms.each do |hypernym|
        puts "hypernym: #{hypernym}"
      end
      puts "---------------------------------"
    end
  end

  puts "--------------------------------"
  # test = Embeddings.perform(words)
  #p test
  puts "\n"
  puts "--------------------------------"
  puts "\n\n"

end
