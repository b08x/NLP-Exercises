#!/usr/bin/env ruby
# frozen_string_literal: false

require 'openai'
client = OpenAI::Client.new(
    access_token: "ollama",
    uri_base: "http://tinybot.syncopated.net:11435/v1",
    request_timeout: 240
    # extra_headers: {
    #   "X-Proxy-TTL" => "43200", # For https://github.com/6/openai-caching-proxy-worker#specifying-a-cache-ttl
    #   "X-Proxy-Refresh": "true", # For https://github.com/6/openai-caching-proxy-worker#refreshing-the-cache
    #   "Helicone-Auth": "Bearer HELICONE_API_KEY", # For https://docs.helicone.ai/getting-started/integration-method/openai-proxy
    #   "helicone-stream-force-format" => "true", # Use this with Helicone otherwise streaming drops chunks # https://github.com/alexrudall/ruby-openai/issues/251
    # }
)

response = client.chat(
    parameters: {
        model: "llava:7b-v1.6-mistral-q4_0", # Required.
        messages: [{ role: "user", content: "Hello!"}], # Required.
        temperature: 0.7,
    })

    puts response.dig("choices", 0, "message", "content")

