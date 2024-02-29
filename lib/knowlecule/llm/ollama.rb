#!/usr/bin/env ruby
# frozen_string_literal: false

require "openai"
require "wikipedia"
client = OpenAI::Client.new(
  access_token: "ollama",
  uri_base: "http://tinybot.syncopated.net:11435",
  request_timeout: 240
)

def get_file_list(path)
  Dir.chdir(path) do
    return `ls -lah`
  end
end


def answer_music_theory_question(question)
  page = Wikipedia.find(question)
  if page.text.nil?
    "I'm sorry, I couldn't find an answer to your question."
  else
    summary = page.summary
    links = page.links.map { |link| "[#{link}](#{link})" }.join(" ")
    "#{summary}\n\n**Sources:** #{links}"
  end
end


def execute_function(function_call)
  function_name = function_call["name"]
  args = function_call["arguments"]
  case function_name
  when "get_file_list"
    get_file_list(args["path"])
  when "answer_music_theory_question"
    answer_music_theory_question(args["question"])
  else
    raise "Unknown function: #{function_name}"
  end
end

response =
  client.chat(
    parameters: {
      model: "llava:7b-v1.6-mistral-q4_0", 
      messages: [
        { role: "system", content: "Use the available functions when responding to a query." },
        { role: "user", content: "What is a major scale in music theory?" }
      ],
      functions: [
        {
          name: "get_file_list",
          description: "Get a list of files",
          parameters: {
            type: :object,
            properties: {
              path: {
                type: :string,
                description: "The folder path, e.g. /home/b08x/"
              }
            },
            required: ["path"]
          }
        },
        {
          name: "answer_music_theory_question",
          description: "Answer a question about music theory",
          parameters: {
            type: :object,
            properties: {
              question: {
                type: :string,
                description: "The question about music theory"
              }
            },
            required: ["question"]
          }
        }
      ]
    }
  )



message = response.dig("choices", 0, "message")
p message

if message["role"] == "assistant" && message["function_call"]
  result = process_function_call(message["function_call"])
  p "Result: #{result}"
end
