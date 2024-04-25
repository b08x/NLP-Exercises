lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'knowlecule/version'

Gem::Specification.new do |spec|
  spec.name = "knowlecule"
  spec.version = Knowlecule::VERSION
  spec.authors = ["Robert Pannick"]
  spec.email = ["rwpannick@gmail.com"]

  spec.summary = "Process text, build knowledge graphs for LLMs."
  spec.homepage = "https://github.com/b08x/knowlecule"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/b08x/knowlecule/issues",
    "changelog_uri" => "https://github.com/b08x/knowlecule/releases",
    "source_code_uri" => "https://github.com/b08x/knowlecule",
    "homepage_uri" => spec.homepage,
    "rubyspec.add_dependencys_mfa_required" => "true"
  }

  # Specify which files should be added to the spec.add_dependency when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rb_sys"
  spec.add_development_dependency "rb-readline"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "solargraph"




  # Runtime dependencies
  # spec.add_dependency 'google_palm_api'
  spec.add_dependency 'algorithms'
  spec.add_dependency 'amazing_print'
  spec.add_dependency 'aoororachain'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'bcrypt_pbkdf'
  spec.add_dependency 'beckett'
  spec.add_dependency 'chroma-db'
  spec.add_dependency 'cohere'
  spec.add_dependency 'cohere-ruby'
  spec.add_dependency 'color',       '~> 1.8'
  spec.add_dependency 'composable_operations'
  spec.add_dependency 'debug_me'
  spec.add_dependency 'decisiontree'
  spec.add_dependency 'docsplit'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'dry-monads'
  spec.add_dependency 'engtagger'
  spec.add_dependency 'epitome'
  spec.add_dependency 'faraday'
  spec.add_dependency 'find'
  spec.add_dependency 'gambiarra'
  spec.add_dependency 'google-cloud-ai_platform-v1'
  spec.add_dependency 'google_search_results'
  spec.add_dependency 'graphr'
  spec.add_dependency 'hashie'
  spec.add_dependency 'hexapdf'
  spec.add_dependency 'highline'
  spec.add_dependency 'hugging-face'
  spec.add_dependency 'jongleur'
  spec.add_dependency 'json'
  spec.add_dependency 'jsonl'
  spec.add_dependency 'kramdown'
  spec.add_dependency 'langchainrb'
  spec.add_dependency 'lemmatizer'
  spec.add_dependency 'lingua'
  spec.add_dependency 'llm_memory'
  spec.add_dependency 'logging'
  spec.add_dependency 'mimemagic'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'net-ssh'
  spec.add_dependency 'networkx'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'ohm'
  spec.add_dependency 'ohm-contrib'
  spec.add_dependency 'oj'
  spec.add_dependency 'ollama-ai'
  spec.add_dependency 'open-uri'
  spec.add_dependency 'open3'
  spec.add_dependency 'open4'
  spec.add_dependency 'openssl'
  spec.add_dependency 'os'
  spec.add_dependency 'pastel'
  spec.add_dependency 'parallel'
  spec.add_dependency 'pdf-reader'
  # spec.add_dependency 'pdf_paradise'
  spec.add_dependency 'pg'
  spec.add_dependency 'pgvector'
  spec.add_dependency 'poppler'
  spec.add_dependency 'pragmatic_segmenter'
  spec.add_dependency 'pragmatic_tokenizer'
  # spec.add_dependency 'prompt_manager'
  spec.add_dependency 'pycall'
  spec.add_dependency 'redcarpet'
  spec.add_dependency 'redic'
  spec.add_dependency 'redis'
  spec.add_dependency 'reline'
  spec.add_dependency 'rouge'
  spec.add_dependency 'ruby-openai'
  spec.add_dependency 'ruby-spacy'
  spec.add_dependency 'rubydown'
  spec.add_dependency 'sad_panda'
  spec.add_dependency 'safe_ruby'
  spec.add_dependency 'scalpel'
  spec.add_dependency 'semver2'
  spec.add_dependency 'sequel'
  spec.add_dependency 'shellwords'
  spec.add_dependency 'socrates'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'standard'
  spec.add_dependency 'stream_lines'
  spec.add_dependency 'sync'
  spec.add_dependency 'syntax_tree'
  spec.add_dependency 'sys-proctable'
  spec.add_dependency 'toml-rb'
  spec.add_dependency 'tomoto'
  spec.add_dependency 'treetop'
  spec.add_dependency 'tty-box'
  spec.add_dependency 'tty-command'
  spec.add_dependency 'tty-config'
  spec.add_dependency 'tty-prompt'
  spec.add_dependency 'tty-screen'
  spec.add_dependency 'tty-spinner'
  spec.add_dependency 'tty-which'
  spec.add_dependency 'wikipedia-client'
  spec.add_dependency 'wordnet'
  spec.add_dependency 'wordnet-defaultdb'
  spec.add_dependency 'yajl'
  spec.add_dependency 'yajl-ruby'
  spec.add_dependency 'yaml'
end
