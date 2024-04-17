# audio_file_path = "path/to/audio.wav"

require "google/cloud/speech"

speech = Google::Cloud::Speech.speech

config = {
  encoding:                     :LINEAR16,
  sample_rate_hertz:            8000,
  language_code:                "en-US",
  enable_automatic_punctuation: true
}

audio_file = File.binread audio_file_path
audio      = { content: audio_file }

operation = speech.long_running_recognize config: config, audio: audio

puts "Operation started"

operation.wait_until_done!

raise operation.results.message if operation.error?

results = operation.response.results

results.each_with_index do |result, i|
  alternative = result.alternatives.first
  puts "-" * 20
  puts "First alternative of result #{i}"
  puts "Transcript: #{alternative.transcript}"
end