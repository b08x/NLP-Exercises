#!/usr/bin/env ruby
# frozen_string_literal: true

require 'daru'
require 'json'

class ProsodicAnalyzer
  attr_reader :mel_energy_df, :onsets_df, :notes_df, :melodia_df, :transcription

  def initialize(mel_energy_csv, onsets_csv, notes_csv, melodia_csv, transcription)
    @mel_energy_df = Daru::DataFrame.from_csv(mel_energy_csv)
    @onsets_df = Daru::DataFrame.from_csv(onsets_csv)
    @notes_df = Daru::DataFrame.from_csv(notes_csv)
    @melodia_df = Daru::DataFrame.from_csv(melodia_csv)
    @transcription = transcription
  end

  def align_features(features_df)
    aligned_data = []
    @transcription.each do |word|
      start_time = word[:start_time]
      end_time = word[:end_time]
      word_text = word[:text]
      word_features = features_df.filter_rows do |row|
        row[:timestamp] >= start_time && row[:timestamp] <= end_time
      end
      aligned_data << { text: word_text, features: word_features }
    end
    aligned_data
  end

  def aligned_mel_energy
    align_features(@mel_energy_df)
  end

  def aligned_onsets
    align_features(@onsets_df)
  end

  def aligned_notes
    align_features(@notes_df)
  end

  def aligned_melodia
    align_features(@melodia_df)
  end

  def print_aligned_data(aligned_data)
    aligned_data.each do |word_data|
      puts "Word: #{word_data[:text]}"
      puts word_data[:features].to_s
    end
  end
end

module TranscriptionParser
  module_function

  def parse_transcription(json_file)
    transcription_data = JSON.parse(File.read(json_file))

    transcription = []
    transcription_data["transcription"].each do |item|
      start_time = convert_timestamp(item['timestamps']['from'])
      end_time = convert_timestamp(item['timestamps']['to'])
      text = item['text'].strip

      transcription << { start_time: start_time, end_time: end_time, text: text }
    end

    transcription
  end

  def convert_timestamp(timestamp)
    hours, minutes, seconds = timestamp.split(':').map(&:to_i)
    (hours * 3600 + minutes * 60 + seconds).to_f
  end
end

source = File.join(ENV["HOME"], "Recordings", "test3")

json_file = File.join(source, "2024-05-22_03-22-03.json" )

transcription = TranscriptionParser.parse_transcription(json_file)

melenergy = File.join(source, "2024-05-22_03-22-03_vamp_vamp-aubio_aubiomelenergy_mfcc.csv")
onsets = File.join(source, "2024-05-22_03-22-03_vamp_vamp-aubio_aubioonset_onsets.csv")
notes = File.join(source, "2024-05-22_03-22-03_vamp_vamp-aubio_aubionotes_notes.csv")
melodia = File.join(source, "2024-05-22_03-22-03_vamp_mtg-melodia_melodia_melody.csv")
analyzer = ProsodicAnalyzer.new(
  melenergy,
  onsets,
  notes,
  melodia,
  transcription
)


aligned_mel_energy = analyzer.aligned_mel_energy
aligned_onsets = analyzer.aligned_onsets
aligned_notes = analyzer.aligned_notes
aligned_melodia = analyzer.aligned_melodia

# Print aligned data
analyzer.print_aligned_data(aligned_mel_energy)
analyzer.print_aligned_data(aligned_onsets)
analyzer.print_aligned_data(aligned_notes)
