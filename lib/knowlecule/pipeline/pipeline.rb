#!/usr/bin/env ruby
# frozen_string_literal: true


# require_relative 'pipeline/text/graph'
require_relative 'preprocessing/text/segment_tokenize'
require_relative 'preprocessing/text/feature_extraction'
require_relative 'preprocessing/text/hypernyms'
require_relative 'preprocessing/text/ldamodeler'



text = <<~TEXT
  Based on the output of the `aplay -l` command, it seems that your system is recognizing multiple audio devices. The JACK server is using the USB audio device (hw:1,0), but your system also has an HDAudio device (hw:0,0 and hw:0,1)
  If you're not hearing any sound, it's possible that the wrong audio device is selected as the default in your Ubuntu sound settings. Here's how you can check and change the default audio device:
  Open the Sound settings in Ubuntu. You can do this by clicking on the volume icon in the top-right corner of the screen and then clicking on 'Sound Settings' or 'Settings' and then 'Sound'
    In the Sound settings, look for the 'Output' section. Here, you should see a list of all recognized audio devices.
    Check which device is currently selected. If the USB audio device (hw:1,0) is selected, try selecting the HDAudio device (hw:0,0 or hw:0,1) instead
    After changing the output device, try playing sound again to see if the issue is resolved.

  If the issue persists, you may need to adjust the configuration of the JACK server to use the correct audio device. You can do this by modifying the .jackdrc file or using the jack_control
  command to change the device option

  Remember to restart the JACK server after making any changes to its configuration. You can do this by using the jack_control stop and jack_control start commands
TEXT



# tokenized_sentences = Knowlecule::Pipeline::Chunker.perform(text)

# tokenized_sentences.each do |words|
#   words.each do |word|
#     p word
#   end
# end




# class Topic < ComposableOperations::ComposedOperation
#   use Modeler
# end

# topics = Topic.perform(chunked)

# p topics



# seg = Segmenter.new(text).perform

# seg.segment.each do |t|
#   tokenize = Tokenizer.new(t).perform
#   p tokenize
#   puts "-------"
#   puts "\n"
# end

#p tokenize
