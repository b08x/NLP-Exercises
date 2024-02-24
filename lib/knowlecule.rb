#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

TMPFS = File.join("/tmp/knowlecule")

Dotenv.load(File.join(__dir__, '..', '.env'))

require "aoororachain"

require "knowlecule/utils/arraylib"
require "knowlecule/utils/glob"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/logging"

require "knowlecule/database/ohm"
require "knowlecule/database/postgres"

require "knowlecule/item"
require "knowlecule/loader"

require "knowlecule/cli"

module Knowlecule
  autoload :CLI, "knowlecule/cli"
  autoload :VERSION, "knowlecule/version"
end

Aoororachain.logger = Logger.new($stdout)
Aoororachain.log_level = Aoororachain::LEVEL_DEBUG
