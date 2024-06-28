#!/usr/bin/env ruby

require_relative 'deepgram/deepgram'
require_relative 'pipeline/segmentation'
require 'ruby-spacy'
require 'linguistics'
require_relative 'pipeline/topic_modeler'

Linguistics.use(:en)

class TextProcessor
  def initialize(num_topics = 5, segmenter_options = {}, topic_modeler_options = {})
    @segmenter_options = segmenter_options
    @nlp = Spacy::Language.new('en_core_web_trf')
    @topic_modeler = TopicModeler.new(20, **topic_modeler_options)
  end

  def process(text)
    sentences = segment_text(text)
    processed_sentences = sentences.map { |sentence| process_sentence(sentence) }
    clean_text = processed_sentences.join(' ')
    @topic_modeler.add_document(clean_text)
  end

  def train_topic_model(iterations = 100)
    @topic_modeler.train(iterations)
  end

  def get_topics(top_n = 10)
    @topic_modeler.get_topics(top_n)
  end

  def save_topic_model
    @topic_modeler.save
  end

  def load_topic_model
    @topic_modeler.load
  end

  private

  def segment_text(text)
    segmenter = TextSegmenter.new(text, @segmenter_options)
    segmenter.execute
  end

  def process_sentence(sentence)
    doc = @nlp.read(sentence)

    # Extract all relevant information from the sentence
    relevant_tokens = doc.select do |token|
      # Include all parts of speech, tags, deps, and named entities
      token.pos_ != '' || token.tag_ != '' || token.dep_ != '' || token.ent_type_ != ''
    end

    logger.debug relevant_tokens

    begin
      en_sentence = sentence.en.sentence
      subject = safe_extract { en_sentence.subject.to_s }
      verb = safe_extract { en_sentence.verb.to_s }
      object = safe_extract { en_sentence.object.to_s }
      logger.debug en_sentence
      logger.debug subject
      logger.debug verb
      logger.debug object

      # Use Linguistics gem for verb infinitive
      infinitive = safe_extract { verb.en.infinitive } if verb
      logger.debug infinitive

      # Use Linguistics gem for word definition (not specific to object)
      definition = safe_extract { object.en.definition } if object

      processed_tokens = relevant_tokens.map do |token|
        {
          text: token.text,
          pos: token.pos_,
          tag: token.tag_,
          dep: token.dep_,
          ent_type: token.ent_type_
        }
      end + [subject, verb, object, infinitive].compact

      logger.debug processed_tokens

      # Filter for nouns, proper nouns, named entities, and adjectives
      filtered_tokens = processed_tokens.select do |token|
        token.is_a?(Hash) &&
        (["NN", "JJ", "RB"].include? token[:tag])
      end.map { |token| token[:text] }

      # filtered_tokens = processed_tokens.select { |token| token.is_a?(Hash) }
      #                                   .map { |token| token[:text] }


      processed_text = filtered_tokens.map { |token| token}.join(' ')

      processed_text += " | #{definition}" if definition

      logger.debug processed_text

      processed_text
    rescue LinkParser::Error => e
      logger.error e.message
    ensure
    end
  end

  def safe_extract
    yield
  rescue StandardError => e
    logger.warn "Warning: #{e.message}"
    nil
  end
end

# Output: [["Speaker", "NOUN", "NN", "ROOT", ""], ["0", "NUM", "CD", "nummod", "CARDINAL"]]

# # Example usage
# tagged_words = [{:text=>"Speaker", :pos=>"NOUN", :tag=>"NN", :dep=>"ROOT", :ent_type=>""}, {:text=>"0", :pos=>"NUM", :tag=>"CD", :dep=>"nummod", :ent_type=>"CARDINAL"}, {:text=>":", :pos=>"PUNCT", :tag=>":", :dep=>"punct", :ent_type=>""}, {:text=>"Alright", :pos=>"INTJ", :tag=>"UH", :dep=>"intj", :ent_type=>""}, {:text=>".", :pos=>"PUNCT", :tag=>".", :dep=>"punct", :ent_type=>""}, "Speaker", ":", "", ""]
# nouns_and_adjectives = extract_nouns_adjectives(tagged_words)
# puts nouns_and_adjectives # Output: ["Speaker"] 


longtext = Item.new('/home/b08x/Recordings/staging/test0001/2024-05-22_23-13-31_deepgram.json')
@text = Deepgram.new(longtext.path)
@text.parse_json

processor = TextProcessor.new(10, { clean: true }, { term_weight: :one })
processor.process(@text.paragraphs.join(' '))

processor.train_topic_model

processor.save_topic_model
