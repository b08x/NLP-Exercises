#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ollama-ai'

# https://github.com/gbaptista/ollama-ai?tab=readme-ov-file#models

#tinydolphin:1.1b-v2.8-fp16

models = [
  { name: "llava", tag: "7b-v1.6-mistral-q4_0" },
  { name: "openhermes2.5-mistral", tag: "7b-q4_K_M" },
  { name: "llama2-uncensored", tag: "latest" },
  { name: "qwen", tag: "7b" },
  { name: "starcoder", tag: "7b-base-q4_K_M" },
  { name: "phi", tag: "latest" },
  { name: "wizard-vicuna-uncensored", tag: "7b" },
  { name: "codellama", tag: "7b"},
  { name: "mistral-openorca", tag: "7b" },
  { name: "tinyllama", tag: "chat" },
  { name: "deepseek-coder", tag: "latest" },
  { name: "falcon", tag: "7b" },
  { name: "neural-chat", tag: "7b-v3.1" }
]

# @client = Ollama.new(
#   credentials: { address: 'http://tinybot.syncopated.net:11435' },
#   options: { server_sent_events: true },
#   connection: { request: { timeout: 120, read_timeout: 120 } }
# )

# models.each do |model|
#   begin
#     puts "#{model[:name]}:#{model[:tag]}"
#     result = @client.pull(
#       { name: "#{model[:name]}:#{model[:tag]}" }
#     ) do |event, raw|
#       puts event
#     end
#   rescue Net::ReadTimeout => e
#     p e
#   end
# end

# def purpose(variables)
#   return value if condition_is_true unless something_is_false
# end
