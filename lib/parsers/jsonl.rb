#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  module ParseJSONL
    module_function

    def parse(file)
      File.open(file, 'r') do |f|
        f.each_line do |line|
          extracted_data = extract_data(line)
          puts extracted_data
          puts "\n"
        end
      end
    end

    def extract_data(jsonl_entry)
      data = JSON.parse(jsonl_entry)
      {
        'name' => data['name'],
        'send_date' => data['send_date'],
        'mes' => data['mes']
      }
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
