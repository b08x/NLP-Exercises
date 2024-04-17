#!/usr/bin/env ruby

require "composable_operations"
# require_relative 'pipeline/text/graph'
require_relative 'text/segment_tokenize'
require_relative 'text/feature_extraction'
require_relative 'text/hypernyms'
require_relative 'text/ldamodeler'

require 'lingua'


text = <<~TEXT
  If you have a telescope, you can decide for yourself if those objects in the sky are quanitifiable objects with valuable properties or less simply; an inconceivably intricate backdrop to distract us from the fact none of us can explain with any certainty why we even exist in the first place. 
  ###
  The human eye is an amazing organ, capable of capturing and processing an incredible amount of information. But what happens when the eye is presented with an image that is warped or distorted? Does the brain simply ignore the distortion, or does it attempt to compensate for it? 

  Black holes and other galaxy-related phenomena have been a source of fascination for scientists and astronomers for centuries. Light behaves strangely around black holes as intense gravity around black holes results in light distortion as well as wavelength shifting due to the high speeds. 

  This results in the visual system receiving a degraded or challenging light source - either dimmed or warped or both. This distorts and shifts the light source that reaches our telescopes and eyes. This forces the visual system to compensate more to make sense of the image. 

  *It makes sense that the weaker the light source, the more the brain has to compensate for the signal loss. It is also assumed that light around a black hole is moving very quickly.* 

  The visual system relies on a process called motion integration or inter-frame integration. This involves combining information from a sequence of blurred images to determine the true shape and position of the moving object over time. This process is also so effective that we are usually unaware of any blurring in the image.

  Specifically, motion-sensitive neurons in the visual cortex store information about an object's position and trajectory. We've being under the impression that trajectories we've calculated over astronomical distances are correct. #toprove: the conditioning of learned mathematical formulas fundamentally skew our perception of such astrological phenomenon. 

  When the eye is looking at an object that is close to the face, the image of the object is projected onto the retina in a distorted way. This is because the lens of the eye is curved, and it bends light rays so that they focus on the retina. However, when the object is close to the face, the lens of the eye cannot bend the light rays enough to focus them on the retina. This results in a distorted image of the object.

  The brain compensates for this distortion by using a process called "retinal remapping." Retinal remapping is the process by which the brain remaps the distorted image of the object onto the retina so that it appears to be in focus. This process is so effective that we are usually unaware of any distortion in the image.

  The human eye is a complex organ, and our understanding of how it works is still incomplete. However, we do know that the eye is responsible for converting light into electrical signals that are sent to the brain. This process is not entirely understood, but it is believed that the eye's photoreceptors, which are located in the retina, play a key role. Photoreceptors are cells that are sensitive to light, and they convert light energy into electrical signals. These signals are then sent to the brain, where they are interpreted as visual images.

  One possible explanation for the strange behavior of light around black holes is that the human eye is not able to accurately perceive light that is emitted  from such a distance. 

  This could be due to the fact that  the round, spherical, globular shape of the eyeball causes light to bend and distort as it passes through, making it difficult for the human eye to accurately perceive it.

  Another possibility  is that the round, spherical shape of the eyeball helps us to perceive distance. This is because when we look at an object, the light rays from that object travel through the eyeball and are focused on the retina. The retina is a thin layer of tissue at the back of the eye that contains photoreceptor cells, which are responsible for converting light into electrical signals. These signals are then sent to the brain, where they are interpreted as visual images. The distance of an object from the eye is determined by the angle of the light rays that enter the eye. The closer the object is, the smaller the angle of the light rays. The farther away the object is, the larger the angle of the light rays. 

  The eyeball is not a perfect sphere, but rather a slightly flattened ellipse. This means that the light that enters the eye is not focused directly on the retina, but rather on a slightly curved surface. This curvature can cause the perception of distance to be distorted, making it appear as though objects are closer or farther away than they actually are.

  > [!ai]+ AI
  >
  > **Sure, here is the semantically segmented chunk of condensed thought in the mean sensible order in terms of generally agreeable sentiment, taking care not to provoke one sensibility in favor of another by using language that prefers one sensibility when contrasted by another:**
  > **Title:** Black Holes: The Grand Conspiracy
  > **Introduction:**
  > * The existence of stars and galaxies is a matter of debate.
  > * Some people believe that they are real, while others believe that they are an illusion.
  > * The human eye is capable of capturing and processing an incredible amount of information.
  > * However, the eye can be fooled by distortions and illusions.
  > **Body:**
  > * Black holes are objects with such strong gravity that nothing, not even light, can escape them.
  > * The light from black holes is distorted and shifted, making them difficult to observe.
  > * The human visual system compensates for this distortion by using a process called "retinal remapping."
  > * This process allows us to see black holes as if they were in focus.
  > * However, it is possible that the human eye is not able to accurately perceive light from black holes.
  > **Conclusion:**
  > * The existence of black holes is a mystery.
  > * We do not know for sure whether they are real or an illusion.
  > * The human eye is a complex organ, and our understanding of how it works is still incomplete.
  > **Semantic Segmentation:**
  > * **Existence of stars and galaxies:** This is a matter of debate.
  > * **Human eye:** The human eye is capable of capturing and processing an incredible amount of information.
  > * **Black holes:** Black holes are objects with such strong gravity that nothing, not even light, can escape them.
  > * **Light from black holes:** The light from black holes is distorted and shifted, making them difficult to observe.
  > * **Human visual system:** The human visual system compensates for this distortion by using a process called "retinal remapping."
  > * **Mystery of black holes:** The existence of black holes is a mystery.
  > **Neutral Language and Objective Analysis:**
  > * The use of neutral language and objective analysis is important in order to avoid bias and prejudice.
  > * In the case of black holes, there is no definitive answer as to whether they are real or an illusion.
  > * It is important to present all sides of the argument and to avoid making any assumptions.
  > **Avoidance of Abuse:**
  > * It is important to avoid using abusive language when discussing controversial topics.
  > * This can lead to further division and conflict.
  > * Instead, it is important to focus on the facts and to present a balanced view of the issue.
  > **Avoidance of Assumptious Correlations:**
  > * It is important to avoid making assumptions about the relationship between two things.
  > * In the case of black holes, there is no evidence to support the claim that they are an illusion.
  > * It is important to base our conclusions on evidence and not on speculation.
  > **Avoidance of Reasoning:**
  > * It is important to avoid reasoning when discussing controversial topics.
  > * This can lead to circular arguments and further division.
  > * Instead, it is important to focus on the facts and to present a balanced view of the issue.
  > **Explanation of Correlations:**
  > * When critically assessing textually conveyed concepts, it is important to explain any correlations that are made.
  > * This helps to ensure that the reader understands the reasoning behind the claims that are being made.
  > * In the case of black holes, there is a correlation between the distortion of light and the difficulty in observing them.
  > * This correlation is explained by the fact that the strong gravity of black holes bends and shifts light waves.
  > **Citing Contrasting Perspectives:**
  > * When discussing controversial topics, it is important to cite contrasting perspectives.
  > * This helps to ensure that the reader is aware of all sides of the argument.
  > * In the case of black holes, there are two contrasting perspectives:
  > * Black holes are real objects.
  > * Black holes are an illusion.
  > * It is important to present both of these perspectives and to avoid favoring one over the other.
  > **Style:**
  > * The style of the writing should be clear and concise.
  > * It should be easy for the reader to understand the main points of the argument.
  > * The use of hyperbole, exaggeration, malapropisms, mispronunciations, non-sequiturs, scientific jargon, nihilistic and existential rants, insults, sarcasm, meandering sentences, exclamations, outbursts, and dramatic pauses should be avoided.


TEXT


content = Lingua::EN::Readability.new(text)

content.paragraphs.each {|x| p x; puts "\n\n"}

# p content
#p content.paragraphs
#p content.sentences
# p content.words
# p content.unique_words
# p content.report

# content.sentences.each do |sentence|
#   begin
#     s = sentence.gsub(/^\\|"|^\s/,"").chomp.strip.dup
#     p Knowlecule::Pipeline::Chunker.perform(s)

#   rescue FrozenError => e
#     p e
#   end
# end






#
#
#
# class Topic < ComposableOperations::ComposedOperation
#   use Modeler
# end
#
# topics = Topic.perform(tokenized_sentences)
#
# p topics

# seg = Knowlecule::Pipeline::Segmenter.new(content.paragraphs).perform
#
# seg.segment.each do |t|
#   tokenize = Knowlecule::Pipeline::Tokenizer.new(t).perform
#   p tokenize
#   puts "-------"
#   puts "\n"
# end
