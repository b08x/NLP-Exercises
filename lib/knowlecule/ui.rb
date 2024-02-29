#!/usr/bin/env ruby
# frozen_string_literal: false

require "dotenv"
Dotenv.load(File.join(__dir__, "..", "..", ".env"))

## Ensure all libs in vendor directory are available
Dir["#{File.expand_path("../vendor", __FILE__)}/*/lib/"].each do |vendor_lib|
  $:.unshift vendor_lib
end

require_relative '../../vendor/aia/lib/aia'

require "os"
require "mercenary"
require "highline/import"
require "cli/ui"

require "knowlecule/version"
require "knowlecule/config"
require "knowlecule/utils/glob"
# require "knowlecule/utils/fzf"
require "knowlecule/utils/arraylib"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/logging"

require 'paint'
require 'color'

require "knowlecule"

