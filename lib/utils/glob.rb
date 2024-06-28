#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  module Glob
    module_function

    FD = "/usr/bin/fd"
    FD_OPTS = "-a -L --show-errors"

    def cmd
      TTY::Command.new(output: $logger, 2 => 1)
    end

    # Strategy Pattern Implementation
    class GlobStrategy
      def initialize(path, regex = nil)
        @path = path
        @regex = regex || "."
      end

      def execute
        raise NotImplementedError, "Subclasses must implement the execute method"
      end

      private

      def fix_encoding(input)
        input.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
      end

      def fd_results
        cmd.run("#{FD} #{@regex} -t #{@type} #{FD_OPTS} #{@path}", only_output_on_error: true)
      end
    end

    class FoldersStrategy < GlobStrategy
      attr_reader :type

      def initialize(path, regex = nil)
        super
        @type = "d"
      end

      def execute
        results = fd_results
        fix_encoding(results.out).split("\n").sort
      end
    end

    class FilesStrategy < GlobStrategy
      attr_reader :type

      def initialize(path, regex = nil)
        super
        @type = "f"
      end

      def execute
        results = cmd.run("#{FD} #{@regex} -t #{@type} #{FD_OPTS} #{@path}", err: :out, only_output_on_error: true)
        fix_encoding(results.out).split("\n").sort
      end
    end

    # Specific File Type Strategies
    class AudioStrategy < GlobStrategy
      def execute
        Dir.glob(File.join(@path, "**/*{,/*/**}.{wav,flac,mp3,aiff,ogg,wma,opus,m4a}"))
      end
    end

    class VideoStrategy < GlobStrategy
      def execute
        Dir.glob(File.join(@path, "**/*{,/*/**}.{mp4,mkv}"))
      end
    end

    class SoundfontsStrategy < GlobStrategy
      def execute
        Dir.glob(File.join(@path, "**/*{,/*/**}.{sfz,sf2,gig}"))
      end
    end

    class MidiStrategy < GlobStrategy
      def execute
        Dir.glob(File.join(@path, "**{,/*/**}/*.{mid,midi}"))
      end
    end

    class DocumentsStrategy < GlobStrategy
      def execute
        Dir.glob(File.join(@path, "**{,/*/**}/*.{pdf,md,markdown,txt,json,html}"))
      end
    end

    # Public API
    def folders(path, regex = nil)
      FoldersStrategy.new(path, regex).execute
    end

    def files(path, regex = nil)
      FilesStrategy.new(path, regex).execute
    end

    def audio(path)
      AudioStrategy.new(path).execute
    end

    def video(path)
      VideoStrategy.new(path).execute
    end

    def soundfonts(path)
      SoundfontsStrategy.new(path).execute
    end

    def midi(path)
      MidiStrategy.new(path).execute
    end

    def documents(path)
      DocumentsStrategy.new(path).execute
    end
  end
end
