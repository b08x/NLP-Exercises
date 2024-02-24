#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib') # Put our local lib in first place

TMPFS = File.join("/tmp/knowlecule")

require "aoororachain"

require "knowlecule/utils/glob"

require "knowlecule/item"
require "knowlecule/import"

require "knowlecule/cli"


module Knowlecule
  autoload :CLI, "knowlecule/cli"
  autoload :VERSION, "knowlecule/version"
end

Aoororachain.logger = Logger.new($stdout)
Aoororachain.log_level = Aoororachain::LEVEL_DEBUG