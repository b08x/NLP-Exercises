#!/usr/bin/env ruby
# frozen_string_literal: true

require 'composable_operations'
require 'ruby-spacy'

# Optional Operation for Sentence Structure Analysis
class SentenceStructureAnalyzer < ComposableOperations::Operation
  processes :pos_tokens

  before do
    @sentences = pos_tokens
  end

  def execute
    p @sentences
    exit
    @sentences.each do |token, attributes|
      doc = $nlp.read(token)

      sentences = doc.sents.map do |sentence|
        {
          text: sentence.text,
          pos_tags: sentence.tokens.map { |t| "#{t.text} (#{t.pos_})" }.join(', '),
          simplified_structure: extract_simplified_structure(sentence)
        }
      end
      return sentences.to_json
    end
  end

  private

  def extract_simplified_structure(sentence)
    subject = sentence.tokens.find { |t| t.dep_ == 'nsubj' }&.text
    verb = sentence.tokens.find { |t| t.pos_ == 'VERB' }&.text
    object = sentence.tokens.find { |t| t.dep_ in ['dobj', 'pobj'] }&.text

    [subject, verb, object].compact.join(' - ')
  end
end

class Check < ComposableOperations::Operation
  processes :dependency_hash

  before do
    @tagged_text = dependency_hash
  end

  def execute
    adjustments = []

    @tagged_text.each do |token, attributes|
      doc = $nlp.read(token)

      # Check for subject-verb agreement issues
      if attributes[:pos] == :VERB && attributes[:dep] == :nsubj && doc.head.tag != 'NNS'
        adjustments << 'Subject-verb agreement issue: singular subject with plural verb'
      end

      # Check for pronoun-antecedent agreement issues
      if attributes[:pos] == :PRON && attributes[:dep] == :nsubj && doc.head.tag != attributes[:tag]
        adjustments << 'Pronoun-antecedent agreement issue: pronoun does not match antecedent in number'
      end

      # Check for tense consistency issues
      if attributes[:pos] == :VERB && attributes[:tag].start_with?('VBD') && doc.tokens.any? do |t|
           t.pos == :VERB && t.tag.start_with?('VBZ')
         end
        adjustments << 'Tense consistency issue: mixed past and present tense verbs'
      end

      # Check for preposition usage issues
      if attributes[:pos] == :ADP && attributes[:dep] == :prep && attributes[:text].downcase == 'to'
        adjustments << "Preposition usage issue: unnecessary 'to' before infinitive verb"
      end

      next if attributes[:text].nil?

      # Check for article usage issues
      if attributes[:pos] == :DET && attributes[:text].downcase == 'a' && attributes[:dep] == :det && doc.head.tag.start_with?('NNP')
        adjustments << 'Article usage issue: unnecessary article before proper noun'
      end
    end

    @tagged_text[:grammar_adjustments] = adjustments.join(', ')
    @tagged_text
  end
end

class NamedEntityRecognizer < ComposableOperations::Operation
  processes :dependency_hash

  def execute
    dependency_hash.each do |token, attributes|
      doc = $nlp.read(token)
      ent = doc.ents.first
      attributes[:ner] = ent.label_ if ent
    end
    dependency_hash
  end
end

class DependencyParser < ComposableOperations::Operation
  processes :text

  def execute
    doc = $nlp.read(text)

    doc.tokens.map do |token|
      [token.text, { lemma: token.lemma, pos: token.pos.upcase.to_sym, tag: token.tag.upcase, dep: token.dep }]
    end.to_h
  end
end

class SpacyFeatureExtractor < ComposableOperations::ComposedOperation
  $nlp = Spacy::Language.new('en_core_web_trf')

  # Define the operations to be used in the pipeline
  use DependencyParser
  use NamedEntityRecognizer
  # use SentenceStructureAnalyzer

  # Override the `execute` method to perform additional processing
  # Override the `execute` method to conditionally run SentenceStructureAnalyzer
  def execute
    # Call the parent class's `execute` method to run the initial pipeline
    super
  end
end

# text = "The cat goed to the store to buy some milk."

text = ARGV[0]

extractor = SpacyFeatureExtractor.new(text)

results_with_sentences = extractor.perform

puts results_with_sentences.to_json
# # Define a function to extract functional grammar adjustments
# def adjust_grammar(text)
#   # Use spaCy to analyze the text
#   nlp = Spacy::Language.new("en_core_web_sm")
#   doc = nlp.read(text)

#   # Extract the functional grammar adjustments
#   adjustments = []
#   doc.tokens.each do |token|
#     # Check if the token is a functional word (e.g., "the", "a", etc.)
#     if token.pos == "det"
#       # Adjust the grammar accordingly
#       adjustments << "Added article"
#     elsif token.pos == "conj"
#       # Adjust the grammar accordingly
#       adjustments << "Added conjunction"
#     end
#   end

#   # Return the adjustments
#   adjustments.join(", ")
# end

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
