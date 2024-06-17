#! /usr/bin/env ruby

require 'daru'
require 'json'

class ProsodicAnalyzer
  attr_reader :mel_energy_df, :onsets_df, :notes_df, :transcription

  def initialize(mel_energy_csv, onsets_csv, notes_csv, transcription)
    # Manually add headers to the CSV files
    headers = ["timestamp", "mel_energy", "mfcc_1", "mfcc_2", "mfcc_3", "mfcc_4", "mfcc_5", "mfcc_6", "mfcc_7", "mfcc_8", "mfcc_9", "mfcc_10", "mfcc_11", "mfcc_12", "mfcc_13"]
    File.open(mel_energy_csv, "r+") do |f|
      # Print the first few rows of the CSV file

      f.readline # Skip the first line (no headers)
      f.seek(0, IO::SEEK_SET)
      f.write(headers.join(",") + "\n" + f.read)
    end

    headers = ["timestamp", "onset"]
    File.open(onsets_csv, "r+") do |f|
      f.readline # Skip the first line (no headers)
      f.seek(0, IO::SEEK_SET)
      f.write(headers.join(",") + "\n" + f.read)
    end

    headers = ["timestamp", "note", "onset", "offset", "confidence"]
    File.open(notes_csv, "r+") do |f|
      f.readline # Skip the first line (no headers)
      f.seek(0, IO::SEEK_SET)
      f.write(headers.join(",") + "\n" + f.read)
    end

    # headers = ["timestamp", "pitch", "confidence"]
    # File.open(melodia_csv, "r+") do |f|
    #   f.readline # Skip the first line (no headers)
    #   f.seek(0, IO::SEEK_SET)
    #   f.write(headers.join(",") + "\n" + f.read)
    # end

    # Load DataFrames without headers
    @mel_energy_df = Daru::DataFrame.from_csv(mel_energy_csv)
    @onsets_df = Daru::DataFrame.from_csv(onsets_csv)
    @notes_df = Daru::DataFrame.from_csv(notes_csv)
    # @melodia_df = Daru::DataFrame.from_csv(melodia_csv)
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

  # def aligned_melodia
  #   align_features(@melodia_df)
  # end

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
    current_sentence = []
    transcription_data["transcription"].each do |item|
      start_time = convert_timestamp(item['timestamps']['from'])
      end_time = convert_timestamp(item['timestamps']['to'])
      text = item['text'].strip

      # Add text to current sentence
      current_sentence << { start_time: start_time, end_time: end_time, text: text }

      # Check for sentence boundary (period, question mark, exclamation mark)
      if text.end_with?('.', '?', '!')
        # Add the complete sentence to the transcription
        transcription << { start_time: current_sentence.first[:start_time], end_time: current_sentence.last[:end_time], text: current_sentence.map { |word| word[:text] }.join(' ') }
        # Reset the current sentence
        current_sentence = []
      end
    end

    # Add any remaining words in the current sentence
    if !current_sentence.empty?
      transcription << { start_time: current_sentence.first[:start_time], end_time: current_sentence.last[:end_time], text: current_sentence.map { |word| word[:text] }.join(' ') }
    end

    transcription
  end

  def convert_timestamp(timestamp)
    hours, minutes, seconds = timestamp.split(':').map(&:to_i)
    (hours * 3600 + minutes * 60 + seconds).to_f
  end
end

source = File.join(ENV["HOME"], "Recordings")

json_file = File.join(source, "textv21.json" )

transcription = TranscriptionParser.parse_transcription(json_file)

transcription.each do |line|
  puts line[:text]
end

# Define classes for TranscriptEntry (with start/end time and text) and FeatureEntry (with feature data)

#
# # Align features
# aligned_mel_energy = align_features(transcription, mel_energy_data)
# aligned_onsets = align_features(transcription, onset_data)
# aligned_notes = align_features(transcription, note_data)
#
# # Print aligned data (similar to Python example)
# aligned_mel_energy.each do |word_data|
#   puts "Word: #{word_data[:text]}"
#   puts word_data[:features]
# end


# melenergy = File.join(source, "2024-05-22_03-22-03_vamp_vamp-aubio_aubiomelenergy_mfcc.csv")
# onsets = File.join(source, "2024-05-22_03-22-03_vamp_vamp-aubio_aubioonset_onsets.csv")
# notes = File.join(source, "2024-05-22_03-22-03_vamp_vamp-aubio_aubionotes_notes.csv")
# melodia = File.join(source, "2024-05-22_03-22-03_vamp_mtg-melodia_melodia_melody.csv")

# analyzer = ProsodicAnalyzer.new(
#   melenergy,
#   onsets,
#   notes,
#   transcription
# )


# aligned_mel_energy = analyzer.aligned_mel_energy
# aligned_onsets = analyzer.aligned_onsets
# aligned_notes = analyzer.aligned_notes
# # aligned_melodia = analyzer.aligned_melodia

# # Print aligned data
# analyzer.print_aligned_data(aligned_mel_energy)
# analyzer.print_aligned_data(aligned_onsets)
# analyzer.print_aligned_data(aligned_notes)
# # analyzer.print_aligned_data(aligned_melodia)
