#!/usr/bin/env ruby
# frozen_string_literal: false

require "dotenv"
Dotenv.load(File.join(__dir__, "..", "..", ".env"))

require "os"
require "mercenary"
require "highline/import"
require "cli/ui"

require "knowlecule/version"
require "knowlecule/config"
require "knowlecule/utils/glob"
require "knowlecule/utils/fzf"
require "knowlecule/utils/arraylib"
require "knowlecule/utils/linked-list"
require "knowlecule/utils/logging"

require 'paint'
require 'color'

require 'gambiarra'
require 'knowlecule/commands'

require File.expand_path('../ui/base_view', __FILE__)
views = Dir[File.expand_path('../ui/views/*', __FILE__)].map { |view| require(view) }


#utils = Dir[File.expand_path("knowlecule/utils/*.rb", __dir__)].map { |util| require(util) }

require "knowlecule"

