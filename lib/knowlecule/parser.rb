#!/usr/bin/env ruby
# frozen_string_literal: true

require "knowlecule/parsers/ansible"
require "knowlecule/parsers/git"
require "knowlecule/parsers/md"
require "knowlecule/parsers/pdf"
require "knowlecule/parsers/ruby"


# A DirectoryLoader points to a path and sets the glob for the files you want to load.
# A loader is also specified. FileLoader just opens and reads the file content.
# The RubyDocParser is set as well. This is optional in case you data is very nice and needs no pre-processing.

module Knowlecule
  class Parser

  end
end
