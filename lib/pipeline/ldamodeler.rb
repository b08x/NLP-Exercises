#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tomoto'

class Modeler < ComposableOperations::Operation
  processes :tokenized_text

  before do
    @model = Tomoto::LDA.new(k: 5, alpha: 0.1, eta: 0.01, min_cf: 0.1, rm_top: 4, seed: 42)
    @model_stuff = {}
    # @model.k = 3 # Number of topics
    # @model.alpha = 0.1 # Dirichlet prior for document-topic distribution
    # @model.eta = 0.01 # Dirichlet prior for topic-word distribution
  end
  def execute
    tokenized_text.each { |t| @model.add_doc(t) }
    @model.burn_in = 100
    @model.train(0)
    p @model.removed_top_words
    100.times do |i|
      @model.train(10)
    end
    @model_stuff[:summary] = @model.summary
    @model_stuff[:topic_words] = @model.topic_words
    @model_stuff[:vocabs] = @model.vocabs
    return @model_stuff
  end
end