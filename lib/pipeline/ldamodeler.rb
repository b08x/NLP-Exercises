require 'pragmatic_tokenizer'
require 'tomoto'
require 'composable_operations'

module Pipeline
  class Sanitizer < ComposableOperations::Operation
    processes :text

    def execute
      clean_text = text.gsub(/\r/,' ').gsub(/\n/,' ').gsub(/\s+/,' ')
      clean_text.gsub!("\t\r ", '')
      clean_text.gsub!('-­‐', '-')
      clean_text.gsub!("•", '')
      clean_text.gsub!("●", '')
      clean_text.gsub!("\n\n", '#keep#')
      clean_text.gsub!("\n", ' ')
      # Fix for an incompatible space character.
      clean_text.gsub!(" ", ' ')
      clean_text.gsub!('#keep#', "\n\n")
      clean_text.gsub!("   ",' ')
      clean_text
    end
  end

  class Tokenizer < ComposableOperations::Operation
    processes :text

    property :punct, default: :all, required: true
    property :stopwords, default: false, required: true

    before do
      @options = {
        remove_stop_words: stopwords,
        punctuation: punct,
        numbers: :all,
        minimum_length: 0,
        remove_emoji: false,
        remove_emails: true,
        remove_urls: true,
        remove_domains: true,
        expand_contractions: true,
        clean: true,
        mentions: :keep_original,
        hashtags: :keep_original,
        classic_filter: true,
        downcase: false,
        long_word_split: 20
      }
    end

    def execute
      p text
      tt = PragmaticTokenizer::Tokenizer.new(@options).tokenize(text)
      p text
    rescue NoMethodError => e
      p e
    ensure
      PragmaticTokenizer::Tokenizer.new(@options).tokenize(text)
    end
  end

  class Modeler < ComposableOperations::Operation
    processes :tokenized_text

    before do
      @model = Tomoto::LDA.new(k: 5, alpha: 0.1, eta: 0.01, min_cf: 0.1, rm_top: 4, seed: 42)
      @model_stuff = {}
      p tokenized_text
      # @model.k = 3 # Number of topics
      # @model.alpha = 0.1 # Dirichlet prior for document-topic distribution
      # @model.eta = 0.01 # Dirichlet prior for topic-word distribution
    end
    def execute
      tokenized_text.each { |t| @model.add_doc(t) }

      @model.burn_in = 100
      @model.train(0)
      p @model.removed_top_words
      100.times do |_i|
        @model.train(10)
      end
      @model_stuff[:summary] = @model.summary
      @model_stuff[:topic_words] = @model.topic_words
      @model_stuff[:vocabs] = @model.vocabs
      @model_stuff
    end
  end

  class Topics < ComposableOperations::ComposedOperation
    # use Tokenizer, punct: :none, stopwords: true
    use Sanitizer
    use Tokenizer
    use Modeler
  end
end

#

$longtext = JSON.parse(File.read('longtext.json'))['text']
