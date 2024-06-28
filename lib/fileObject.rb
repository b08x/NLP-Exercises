#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mimemagic'
require 'ohm'
require 'ohm/contrib'
require 'tty-command'

module Knowlecule
  module Glob
    module_function

    include Logging

    FD = "/usr/bin/fd"
    FD_OPTS = "-a -L --show-errors"

    # Redis connection (replace with your Redis configuration)
    # $redis = Redis.new(host: 'localhost', port: 6379)

    Ohm.redis = Redic.new("redis://127.0.0.1:6379")

    # FileObject Class
    class FileObject
      attr_reader :path, :extension, :name, :type, :ctime, :mtime, :media_type

      def initialize(path)        
        @path = Pathname.new(path).cleanpath.to_s
        @extension = File.extname(path)
        @name = File.basename(path, ".").gsub(@extension, "")
        @type = mime
        @ctime = File.stat(path).ctime
        @mtime = File.stat(path).mtime
        @media_type = determine_type(path)
      end

      def mime
        mime = MimeMagic.by_magic(File.open(@path))
        mime&.type # unless mime.nil?
      rescue NoMethodError
        MimeMagic.by_path(File.open(@path)).type
      end

      def determine_type(path)
        # Implement logic to determine file type based on extension or content
        # Example:
        case File.extname(path)
        when '.wav', '.flac', '.mp3', '.aiff', '.ogg', '.wma', '.opus', '.m4a'
          :audio
        when '.mp4', '.mkv'
          :video
        when '.sfz', '.sf2', '.gig'
          :soundfonts
        when '.mid', '.midi'
          :midi
        when '.pdf', '.md', '.markdown', '.txt', '.json', '.html'
          :documents
        else
          :unknown
        end
      end

      def store_metadata
        # Store metadata in Redis
        $redis.hset("file:#{File.basename(@path)}", "path", @path)
        $redis.hset("file:#{File.basename(@path)}", "type", @type)
      end
    end

    # Command Pattern Implementation (modified)
    class GlobCommand
      attr_reader :path, :regex, :type

      def initialize(path, regex = nil, type = nil)
        @path = path
        @regex = regex || "."
        @type = type
      end

      def execute
        raise NotImplementedError, "Subclasses must implement the execute method"
      end

      private

      def fix_encoding(input)
        input.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
      end

      def cmd
        TTY::Command.new(output: $logger, 2 => 1)
      end

      def fd_results
        cmd.run("#{FD} #{@regex} -t #{@type} #{FD_OPTS} #{@path}", only_output_on_error: true)
      end
    end

    # Concrete Command Classes (modified)
    class FoldersCommand < GlobCommand
      def initialize(path, regex = nil)
        super(path, regex, "d")
      end

      def execute
        results = fd_results
        fix_encoding(results.out).split("\n").sort.map { |file| FileObject.new(file).store_metadata }
      end
    end

    class FilesCommand < GlobCommand
      def initialize(path, regex = nil)
        super(path, regex, "f")
      end

      def execute
        results = cmd.run("#{FD} #{@regex} -t #{@type} #{FD_OPTS} #{@path}", err: :out, only_output_on_error: true)
        fix_encoding(results.out).split("\n").sort.map { |file| FileObject.new(file).store_metadata }
      end
    end

    # Public API (modified)
    def folders(path, regex = nil)
      FoldersCommand.new(path, regex).execute
    end

    def files(path, regex = nil)
      FilesCommand.new(path, regex).execute
    end

  end
end
