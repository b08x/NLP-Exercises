#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule

  class ParseJSONL
    attr_reader :file_path, :file_content
    attr_accessor :parsed

    def initialize(file_path)
      @file_path = Pathname.new(file_path).cleanpath.to_s
      @file_content = File.read(@file_path)
      parse
    end

    def parse
      @parsed = JSONL.parse(@file_content)
    end

  end

end


# chatlog = File.join("/home/b08x/Workspace/Characters/config/chats/Steve Tomotolier/Steve Tomotolier - 2024-5-18@04h36m41s.jsonl")
# output = Knowlecule::ParseJSONL.new(chatlog)

# output.parsed.each { |x| p x.keys }

# extracted_data = output.parsed.map do |entry|
#   { "name" => entry["name"], "mes" => entry["mes"] }
# end

# File.open("extracted_data.json", "w") do |f|
#   f.write(JSON.pretty_generate(extracted_data))
# end