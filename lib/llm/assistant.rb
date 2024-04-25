#!/usr/bin/env ruby
# frozen_string_literal: false

require 'langchain'
require 'openai'
require 'safe_ruby'

# client = OpenAI::Client.new(
#   access_token: "ollama",
#   uri_base: "http://tinybot.syncopated.net:11435",
#   request_timeout: 240
#   # extra_headers: {
#   #   "X-Proxy-TTL" => "43200", # For https://github.com/6/openai-caching-proxy-worker#specifying-a-cache-ttl
#   #   "X-Proxy-Refresh": "true", # For https://github.com/6/openai-caching-proxy-worker#refreshing-the-cache
#   #   "Helicone-Auth": "Bearer HELICONE_API_KEY", # For https://docs.helicone.ai/getting-started/integration-method/openai-proxy
#   #   "helicone-stream-force-format" => "true", # Use this with Helicone otherwise streaming drops parts # https://github.com/alexrudall/ruby-openai/issues/251
#   # }
# )

openai = Langchain::LLM::OpenAI.new(
  api_key: "ollama", 
  llm_options: { 
    uri_base: "http://tinybot.syncopated.net:11435", 
    request_timeout: 240
  },
  default_options: {
    n: 1,
    temperature: 0.3,
    chat_completion_model_name: "llava:7b-v1.6-mistral-q4_0"
  }
)

thread = Langchain::Thread.new

assistant = Langchain::Assistant.new(
  llm: openai,
  thread: thread,
  instructions: "execute this ruby code",
  tools: [
    # Langchain::Tool::GoogleSearch.new(api_key: ENV["SERPAPI_API_KEY"])
    ruby_code_interpreter = Langchain::Tool::RubyCodeInterpreter.new
  ]
)

# assistant.tools.first.execute input: 'puts "hey"'
assistant.add_message content: 'puts "hey"', tool_calls: [{name: "ruby_code_interpreter"}]

assistant.run(auto_tool_execution: true)


p assistant.thread.messages

