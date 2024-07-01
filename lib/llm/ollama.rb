#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ollama-ai'

# https://github.com/gbaptista/ollama-ai?tab=readme-ov-file#models

module OllamaClient
  
  def self.models
    [
      { name: "gemma2", tag: "9b" },
      { name: "phi3", tag: "3.8b" },
      { name: "qwen2", tag: "0.5b" },
      { name: "codellama", tag: "2b"},
      { name: "llava-phi3", tag: "3.8b" }
    ]
  end

  def self.client
    @client ||= Ollama.new(
      credentials: { address: 'http://tinybot.syncopated.net:11435' },
      options: { server_sent_events: true },
      connection: { request: { timeout: 120, read_timeout: 120 } }
    )
  end

  def self.pull_model(model)
    begin
      puts "#{model[:name]}:#{model[:tag]}"
      result = client.pull(
        { name: "#{model[:name]}:#{model[:tag]}" }
      ) do |event, raw|
        puts event
      end
    rescue Net::ReadTimeout => e
      p e
    end
  end

  def self.run
    models.each do |model|
      pull_model(model)
    end
  end
end
