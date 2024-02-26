#!/usr/bin/env ruby
# frozen_string_literal: false

require "os"
require "mercenary"
require "highline/import"
require "cli/ui"

require "knowlecule"
require "knowlecule/config"
utils = Dir[File.expand_path('../ui/views/*', __FILE__)].map { |view| require(view) }
