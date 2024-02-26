#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  module Util
    module FZF
      module_function

      # https://junegunn.kr/2016/02/using-fzf-in-your-program
      def with_filter(command)
        io = IO.popen(command, "r+")
        begin
          stdout = $stdout
          $stdout = io
          begin
            yield
          rescue StandardError
            nil
          end
        ensure
          $stdout = stdout
        end
        io.close_write
        io.readlines.map(&:chomp)
      end

      def fuzzyplay(files)
        with_filter('fzf -m --cycle --layout=reverse-list --border=rounded --preview="bat {}"')
        files.each do |n|
          puts n
        end
      end
    end
  end
end
