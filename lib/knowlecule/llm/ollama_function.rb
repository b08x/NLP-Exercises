#!/usr/bin/env ruby
require "json"
require "net/http"
require "uri"

class Ollama
  def initialize(model: "codellama:7b")
    @model = model
  end

  def generate_full_completion(prompt:, **kwargs)
    params = {
      "model": @model,
      "prompt": prompt,
      "stream": false
    }.merge(kwargs)

    response = Net::HTTP.post(
      URI.parse("http://tinybot.syncopated.net:11435/api/generate"),
      params.to_json,
      "Content-Type": "application/json"
    )

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      { "error": "API call error: #{response.body}" }
    end
  end

  def function_to_json(func)
    signature = func.parameters
    type_hints = func.parameters.map { |_, type| type }

    function_info = {
      "name": func.name,
      "description": func.doc,
      "parameters": {
        "type": "object",
        "properties": {}
      },
      "returns": type_hints.last.to_s
    }

    signature.each do |name, _|
      param_type = type_hints.find { |type| type.to_s.include?(name) }.to_s
      function_info["parameters"]["properties"][name] = { "type": param_type }
    end

    JSON.pretty_generate(function_info)
  end

  def main
    functions_prompt = <<-EOF
    You have access to the following tools:
    #{function_to_json(get_weather)}
    #{function_to_json(calculate_mortgage_payment)}
    #{function_to_json(get_directions)}
    #{function_to_json(get_article_details)}

    You must follow these instructions:
    Always select one or more of the above tools based on the user query
    If a tool is found, you must respond in the JSON format matching the following schema:
    { "tools": { "tool": "<name of the selected tool>", "tool_input": <parameters for the selected tool, matching the tool's JSON schema> } }
    If there are multiple tools required, make sure a list of tools are returned in a JSON array.
    If there is no tool that match the user request, you will respond with empty json.
    Do not add any additional Notes or Explanations

    User Query:
    EOF

    prompts = [
      "What's the weather in London, UK?",
      "Determine the monthly mortgage payment for a loan amount of $200,000, an interest rate of 4%, and a loan term of 30 years.",
      "What's the current exchange rate for GBP to EUR?",
      "I'm planning a trip to Killington, Vermont (05751) from Hoboken, NJ (07030). Can you get me weather for both locations and directions?",
    ]

    prompts.each do |prompt|
      puts "❓#{prompt}"
      response = generate_full_completion(prompt: functions_prompt + prompt)
      puts JSON.pretty_generate(response)
      puts "Total duration: #{response["total_duration"] / 1e9} seconds"
    end
  end
end

Ollama.new.main
