#!/usr/bin/env ruby
# frozen_string_literal: false
require 'faraday'
require 'json'

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

      def inference(question, overrideConfig)
        retries = 0
        data = { "question" => question, "overrideConfig" => overrideConfig }.to_json
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
        request = Net::HTTP::Post.new(@uri.path, HEADERS)
        @conn.post do |req|
          req.url HOST
          req.headers = HEADERS
          req.body = data
        end
      end
    end

  end
end