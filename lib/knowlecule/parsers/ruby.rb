#!/usr/bin/env ruby
# frozen_string_literal: true

# You can define a custom Parser to clean data and maybe extract metadata.
# Here is the code of RubyDocParser that does exactly that.
class RubyDocParser
  def self.parse(text)
    name_match = text.match(/Name (\w+)/)
    constant_match = text.match(/Constant (\w+)/)

    object_match = text.match(/Object (\w+)/)
    method_match = text.match(/Method ([\w\[\]\+\=\-\*\%\/]+)/)

    metadata = {}
    metadata[:name] = name_match[1] if name_match
    metadata[:constant] = constant_match[1] if constant_match
    metadata[:object] = object_match[1] if object_match
    metadata[:method] = method_match[1] if method_match
    metadata[:lang] = :ruby
    metadata[:version] = "3.2"

    text.gsub!(/\s+/, " ").strip!
    [text, metadata]
  end
end
