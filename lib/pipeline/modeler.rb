#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tomoto'
require 'pathname'
  

module TopicModeling
  def add(tokens)
    raise NotImplementedError
  end
end

class Modeler
  include TopicModeling

  attr_accessor :model, :save_path

  def initialize(save_path)
    @model = Tomoto::LDA.new(k: 10, alpha: 0.1, eta: 0.01, min_cf: 0.1, rm_top: 4, seed: 42)
    @save_path = Pathname.new(save_path).cleanpath.to_s
  end

  def add(tokens)
    @model.add_doc(tokens)
  end

  def train
    @model.train(0)
    puts "Num docs: #{@model.num_docs}, Vocab size: #{@model.used_vocabs.length}, Num words: #{@model.num_words}"
    puts "Removed top words: #{@model.removed_top_words}"
    puts "Training..."
    100.times do |i|
      @model.train(10)
      puts "Iteration: #{i * 10}\tLog-likelihood: #{@model.ll_per_word}"
    end
  end

  def summary
    puts @model.summary
  end

  def save
    puts "Saving..."
    @model.save(save_path)
  end
end