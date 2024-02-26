#!/usr/bin/env ruby
# frozen_string_literal: false

require "openai"
client = OpenAI::Client.new(
  access_token: "ollama",
  uri_base: "http://tinybot.syncopated.net:11435",
  request_timeout: 240
  # extra_headers: {
  #   "X-Proxy-TTL" => "43200", # For https://github.com/6/openai-caching-proxy-worker#specifying-a-cache-ttl
  #   "X-Proxy-Refresh": "true", # For https://github.com/6/openai-caching-proxy-worker#refreshing-the-cache
  #   "Helicone-Auth": "Bearer HELICONE_API_KEY", # For https://docs.helicone.ai/getting-started/integration-method/openai-proxy
  #   "helicone-stream-force-format" => "true", # Use this with Helicone otherwise streaming drops chunks # https://github.com/alexrudall/ruby-openai/issues/251
  # }
)

# response = client.chat(
#   parameters: {
#     model: "llava:7b-v1.6-mistral-q4_0", # Required.
#     messages:    [
#       { role: "system", content: "Behave as a Linux Systems Engineer" },
#       { role: "user", content: "Describe Linux Audio" }
#     ], # Required.
#     temperature: 0.7
#   }
# )
#
# puts response.dig("choices", 0, "message", "content")

#-------------------

# def get_file_list(path:)
#   Dir.chdir(path) do
#     return `ls -lah`
#   end
# end

# response =
#   client.chat(
#     parameters: {
#       model: "llava:7b-v1.6-mistral-q4_0", # Required.
#       messages: [
#         {
#           role: "user",
#           content: "Describe the contents of /home/b08x/Workspace/knowlecule"
#         }
#       ],
#       functions: [
#         {
#           name: "get_file_list",
#           description: "Get a list of files in a given location",
#           parameters: {
#             type: :object,
#             properties: {
#               path: {
#                 type: :string,
#                 description: "The folder path, e.g. /home/b08x/Worksapce/knowlecule"
#               }
#             },
#             required: ["path"]
#           }
#         }
#       ]
#     }
#   )

# message = response.dig("choices", 0, "message")

# if message["role"] == "assistant" && message["function_call"]
#   function_name = message.dig("function_call", "name")
#   args =
#     JSON.parse(
#       message.dig("function_call", "arguments"),
#       { symbolize_names: true }
#     )

#   case function_name
#   when "get_file_list"
#     get_file_list(**args)
#   end
# end

# p message
