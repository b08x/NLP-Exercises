#!/usr/bin/env ruby
# frozen_string_literal: false

require "faraday"
require "json"

module Knowlecule
  module LLM
    class Flowise
      MAX_RETRY = 60

      HOST = ENV.fetch('FLOWISE_HOST')
      HEADERS = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV.fetch('FLOWISE_API_KEY', nil)}"
      }

      attr_reader :chatflow

      def initialize(chatflow)
        @chatflow = chatflow
        @uri = URI.parse(HOST)
        @conn = Faraday.new(url: HOST, headers: HEADERS)
      end

      def inference(question, override)
        retries = 0
        data = { "question" => question, "overrideConfig" => override }.to_json
        begin
          response = make_request(data)
          JSON.parse(response.body)
        rescue StandardError
          retry if (retries += 1) < MAX_RETRY
          sleep 1
        end
      end

      private

      def make_request(data)
        # request = Net::HTTP::Post.new(@uri.path, HEADERS)
        @conn.post do |req|
          req.url HOST
          req.headers = HEADERS
          req.body = data
        end
      end
    end
  end
end


# curl http://ninjabot.syncopated.net:3002/api/v1/prediction/ecf5c824-2b18-43ab-8eb9-2a8a750d4b29 \
    # -X POST \
    # -d '{"question": "Explain the `TextEmbeddings` class", "overrideConfig": {"collectionName": "monadic", "chromaURL": "http://ninjabot.syncopated.net:8000" }}' \
    # -H "Content-Type: application/json"
# curl http://ninjabot.syncopated.net:3002/api/v1/prediction/31569551-f932-4291-a2c5-16d095387f05 \
    # -X POST \
    # -d '{"question": "Provide high-level overview of repository", "overrideConfig": {"repoLink": "https://github.com/andreibondarev/langchainrb", "branch": "main", "recursive": true }}' \
    # -H "Content-Type: application/json"