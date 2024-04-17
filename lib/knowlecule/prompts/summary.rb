#!/usr/bin/env ruby
# frozen_string_literal: false

require "openai"
require "google_palm_api"
require "cohere"
require "langchainrb"



TOT_PROMPT = <<~TEXT
  Elaborate on the input text using a tree-of-thoughts framework. Generate a summary that includes using Ruby libraries. If there are multiple possible summaries, choose the one that is most concise and coherent. 
TEXT

# Function to generate a prompt template for summarizing text
def generate_summarization_prompt_template(max_tokens)
  prompt_template = Langchain::Prompt::PromptTemplate.new(
    template: "#{TOT_PROMPT} Make sure the output summary does not exceed #{max_tokens} tokens.\n{text}",
    input_variables: ["text"]
  )
end

# Function to save the prompt template to a file
def save_prompt_template(prompt_template, file_path)
  prompt_template.save(file_path: file_path)
end

# Function to load the summarization prompt template
def load_summarization_prompt_template
  prompt_template = Langchain::Prompt.load_from_path(file_path: "summarization_prompt_template.json")

  prompt_template
end

# Function to generate a summary using the summarization prompt template
def generate_summary(text, prompt_template, llm)
  prompt = prompt_template.format(text: text)
  response = llm.chat(prompt: prompt)

  #response.raw_response["choices"][0]["message"]["content"]
  response
end

PALM = Langchain::LLM::GooglePalm.new(api_key: ENV["GOOGLE_PALM_API_KEY"], default_options: {
  temperature: 0.4,
  dimension: 768, # This is what the `embedding-gecko-001` model generates
  completion_model_name: "text-bison-001",
  chat_completion_model_name: "chat-bison-001",
  embeddings_model_name: "embedding-gecko-001"
})

OPENAI = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"], default_options: {
  n: 1,
  temperature: 0.0,
  completion_model_name: "gpt-3.5-turbo-1106",
  chat_completion_model_name: "gpt-3.5-turbo-1106",
  embeddings_model_name: "text-embedding-ada-002",
  dimension: 1536
})

# COHERE = Langchain::LLM::Cohere.new(api_key: ENV["COHERE_API_KEY"], default_options: {
#   temperature: 0.0,
#   completion_model_name: "command",
#   embeddings_model_name: "small",
#   dimension: 1024,
#   truncate: "START"
# })

COHERE = Langchain::LLM::Cohere.new(api_key: ENV["COHERE_API_KEY"])

# Example Usage
max_tokens = 512
prompt_template = generate_summarization_prompt_template(max_tokens)

text = <<~TEXT
  An ontology establishes the fundamental concepts and their interrelationships within a particular field of knowledge. It functions like a specialized dictionary that defines terms and their rules of association. This shared vocabulary provides a common ground for understanding and communicating within that domain.

  Using an structured format such as ontology helps ensure that facts and entities are interconnected in a meaningful and organized manner when processing data to be used with a large language model. It establishes a standardized format, enabling diverse systems to seamlessly exchange and interpret information

  A knowledge graph is a structured representation of facts and concepts, along with the relationships between them. By incorporating knowledge graphs into GPT models applications, we can enhance their ability to reason, ground their outputs in factual information, and generate more comprehensive and informative responses.

  Knowledge graphs are like vast, interconnected tapestries of information, where facts and relationships are woven together to form a rich and detailed tapestry of knowledge. They capture the essence of the world around us, representing it in a way that computers can understand and process.
TEXT

summary = generate_summary(text, prompt_template, PALM)

p summary

puts summary.raw_response



# "The internet originated in the 1960s as a US military network called ARPANET. In the 1970s, the TCP/IP protocol enabled different networks to connect, forming the modern internet."

