#!/usr/bin/env ruby
# frozen_string_literal: true

require 'linguistics'
require 'ruby-spacy'

include Logging

module Tagging
  include Linguistics
  def grammars(text)
    raise NotImplementedError
  end
end

class SpacyFeatureExtractor
  include Tagging

  attr_accessor :nlp, :spacy, :deps, :ners, :sentences

  def initialize
    Linguistics.use(:en)
    @nlp = Spacy::Language.new('en_core_web_trf')
  end

  def sentences(paragraph)
    doc = @nlp.read(paragraph)

    @sentences = doc.sents.map do |sentence|
      {
        text: sentence.text,
        parts_of_speech: sentence.tokens.map do |t|
                          { t.text => { pos: t.pos_, tag: t.tag_, dep: t.dep_ } }
                        end.reduce({}, :merge),
        ners: sentence.ents.map { |e| "#{e.text} (#{e.label_})" }.join(', '),
        subjects: extract_subjects(sentence.text),
        main_verb: extract_main_verb(sentence),
        noun_phrases: extract_noun_phrases(sentence),
        nouns: extract_nouns(sentence),
        adjectives: extract_adjectives(sentence),
        verbs: extract_verbs(sentence),
        adverbs: extract_adverbs(sentence)

      }
    end
    @sentences.to_json
  end

  private

  def extract_nouns(sentence) # Modify method to take a sentence object
    sentence.tokens.select { |t| t.pos_ == 'NOUN' }.map(&:text)
  end

  def extract_adjectives(sentence) # Modify method to take a sentence object
    sentence.tokens.select { |t| t.pos_ == 'ADJ' }.map(&:text)
  end

  def extract_verbs(sentence) # Modify method to take a sentence object
    sentence.tokens.select { |t| t.pos_ == 'VERB' }.map(&:text)
  end

  def extract_adverbs(sentence) # Modify method to take a sentence object
    sentence.tokens.select { |t| t.pos_ == 'ADV' }.map(&:text)
  end

  def extract_subjects(text)
    sentence = text.en.sentence
    sentence.subject.to_s
  rescue LinkParser::Error => e
    logger.warn "#{e.message}"
    puts "#{e.message}\n"
  end

  def extract_noun_phrases(sentence)
    noun_phrases = []
    sentence.tokens.each do |token|
      # Check if the token is a head noun (e.g., has a dependency relation like 'nsubj' or 'dobj')
      if token.dep_ == 'nsubj' || token.dep_ == 'dobj'
        # Find all dependents of the head noun
        dependents = sentence.tokens.select { |t| t.head == token }
        # Combine the head noun and its dependents into a noun phrase
        noun_phrase = [token.text] + dependents.map(&:text)
        noun_phrases << noun_phrase.join(' ')
      end
    end
    noun_phrases
  end
  
  def extract_main_verb(sentence)
    sentence.tokens.select { |t| t.dep_ == 'ROOT' }.map(&:text).first
  end

end
