#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open3'
require 'open4'
require 'json'

module Knowlecule
  module Util
    module Command
      module_function

      def run(command=[])
        pid, stdin, stdout, stderr = Open4::popen4(command)
        stdout_data = stdout.gets
        stdout.close
        stderr_data = stderr.gets
        stderr.close
        exit_code = $?.exitstatus unless $?.nil?

        [stdout_data, stderr_data, exit_code]
      end

      def run_system(command)
        _, stdout, stderr, wait_thr = Open3.popen3(command)
        stdout_data = stdout.gets(nil)
        stdout.close
        stderr_data = stderr.gets(nil)
        stderr.close
        exit_code = wait_thr.value

        [stdout_data, stderr_data, exit_code]
      end

    end
  end
end

def parse_output(data)
  delimiter = "\n\n"
  parsed_text = data.split(delimiter).last.strip

  return nil if parsed_text.nil?
  #JSON.parse(parsed_text)
  puts "#{parsed_text}"
#  return parsed_text.class
end

def notebook(path)
  command = <<~PYTHON
    python - << EOF
    import logging
    import sys

    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    logging.getLogger().addHandler(logging.StreamHandler(stream=sys.stdout))
    
    from llama_index.readers.obsidian import ObsidianReader

    documents = ObsidianReader(
      "#{path}"
    ).load_data()
    
    print(documents[4])
  PYTHON

  stdout_data, stderr_data, exit_code = Knowlecule::Util::Command.run_system(command)

  if exit_code != 0
    # logger.warn("Failed to load documents: #{stderr_data}")
    puts "Failed to load documents: #{stderr_data}"
    return nil
  end

  # logger.debug("documents loaded")
  parse_output(stdout_data)
  
end

path = File.join(ENV["HOME"], "Workspace", "syncopatedNotes", "website", "_notes")

notebook(path)