#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ruby-spacy'

include Logging

module Tagging
  def grammars(text)
    raise NotImplementedError
  end
end

class SpacyFeatureExtractor
  include Tagging

  attr_accessor :nlp, :spacy, :deps, :ners, :sentences

  def initialize
    @nlp = Spacy::Language.new('en_core_web_trf')
  end

  def sentences_to_json(paragraphs)
      doc = @nlp.read(paragraphs)

      @sentences = doc.sents.map do |sentence|
        {
          text: sentence.text,
          pos_tags: sentence.tokens.map { |t| "#{t.text} (#{t.pos_})" }.join(', '),
          label: sentence.ents.map { |e| "#{e.text} (#{e.label_})" }.join(', '),
          simplified_structure: extract_simplified_structure(sentence)
        }
      end
      return @sentences.to_json
  end

  private

  def extract_simplified_structure(sentence)
    subject = sentence.tokens.find { |t| t.dep_ == 'nsubj' }&.text
    verb = sentence.tokens.find { |t| t.pos_ == 'VERB' }&.text
    object = sentence.tokens.find { |t| t.dep_ in ['dobj', 'pobj'] }&.text

    [subject, verb, object].compact.join(' - ')
  end

  def subj_verb_agree(ahash)
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
  # class Lemma

  #   before do
  #     @lem = Lemmatizer.new
  #   end

  #   def execute
  #     @lem.lemma(word, :noun)
  #   end
  # end


end