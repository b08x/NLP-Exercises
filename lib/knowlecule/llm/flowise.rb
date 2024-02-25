#!/usr/bin/env ruby
# frozen_string_literal: false
module Knowlecule
  module LLM
    class Flowise
      # Retry connecting to the model for 1 minute
      MAX_RETRY = 60

      HOST = "http://ninjabot.syncopated.net:3002/api/v1/prediction/3306053d-3006-457e-a417-47298b8caf13"

      HEADERS = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV.fetch('FLOWISE_API_KEY', nil)}"
      }

      attr_reader :function, :model

      def initialize(function)
        @function = function
        @api_url = HOST
      end

      def create_json_object(question, overrideConfig)
        {
          "question": question,
          "overrideConfig": overrideConfig
        }.to_json
      end

      def inference(question, overrideConfig)
        retries = 0

        data = {
          "question" => question,
          "overrideConfig" => overrideConfig
        }

        begin
          uri = URI.parse(@api_url)

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = false # Use HTTPS

          request = Net::HTTP::Post.new(uri.path, HEADERS)

          request.body = data.to_json

          response = http.request(request)

          # Handle the response as needed
          JSON.parse(response.body)

        rescue StandardError => e
          p e
          if retries < MAX_RETRY
            retries += 1
            sleep 1
            retry
          else
            raise exception
          end
        end

      end



    end
  end
end

# q = Knowlecule::LLM::Flowise.new("search")
#
# overrideConfig = {}
#
# question = "Generate a high-level overview of a Ruby application that process documents using NLP methods"
#
#
#
# overrideConfig["chainName"] = "CohereChain"
# overrideConfig["systemMessagePrompt"] = "Summarize the git diff < 120 characters"
# overrideConfig["temperature"] = 0.3
# overrideConfig["maxTokens"] = 1024
#
# p q.inference(diff, overrideConfig)
