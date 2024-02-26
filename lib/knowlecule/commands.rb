# frozen_string_literal: true

require 'knowlecule'
require 'knowlecule/renderers'
require 'knowlecule/commands/command'

Dir[File.expand_path('../commands/*', __FILE__)].map do |f|
  require(f)
end
