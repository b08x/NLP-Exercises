#!/usr/bin/env ruby
# frozen_string_literal: false

$:.unshift File.expand_path(File.join(__dir__, "..", "lib"))

require "drydock"
require "highline/import"

module Knowlecule
  class CLI
    extend Drydock

    default :welcome
    debug :on

    # before do
    # end

    about "about"
    command :about do |_obj|
      puts "hey...this is what this is about!"
    end

    about "main menu"
    command :menu do |_obj|
      Knowlecule::Menu.start
    end

    about "import one or more files and/or folders"
    command :import do |obj|
      require "pathname"

      sources = obj.argv.map {|source| Pathname.new(source)}

      sources.each do |path|
        unless path.realdirpath.exist?
          puts "#{path} not valid...exiting"; exit
        end
      end

      files = Knowlecule::Loader.new(sources)
      files.import
    end

  end # end cli class
end # end soundbot module
