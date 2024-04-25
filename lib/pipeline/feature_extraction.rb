#!/usr/bin/env ruby
# frozen_string_literal: true
require 'ruby-spacy'

class DependencyParser < ComposableOperations::Operation
  processes :parts

  before do
    @nlp = Spacy::Language.new('en_core_web_lg')
  end

  def execute
    parts.map do |segment|
      doc = @nlp.read(segment)

      doc.map { |token| [token.text, { lemma: token.lemma, pos: token.tag.downcase.to_sym, dep: token.dep }] }.to_h

      #doc.tokens.map { |token| [token.text, { dep: token.dep_, pos: token.pos_.downcase.to_sym }] }.to_h
      # doc.tokens.each {|t| p t.dep_}
    end
  end
end

class NamedEntityRecognizer < ComposableOperations::Operation
  processes :text

  before do
    @nlp = Spacy::Language.new('en_core_web_sm')
  end

  def execute
    doc = @nlp.read(text)
    doc.ents.map { |ent| [ent.text, ent.label_] }.to_h
  end
end

# class SpacyEmbeddings < ComposableOperations::Operation
#   processes :text

#   before do
#     @api_key = ENV["OPENAI_API_KEY"]
#     @nlp = Spacy::Language.new('en_core_web_sm')
#   end

#   def execute
#     doc = @nlp.read(text)
#     vectors = doc.openai_embeddings(access_token: api_key)
#   end
# end
