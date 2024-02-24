#!/usr/bin/env ruby
# frozen_string_literal: false

require "drydock"
require "highline/import"

module Knowlecule
  class CLI
    extend Drydock

    default :welcome
    debug :on

    # before do
    #   @hostname = `cat /etc/hostname`.strip
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
        directory_loader = Aoororachain::Loaders::DirectoryLoader.new(path: "#{path.cleanpath.to_s}", glob: "**/*.pdf", loader: Aoororachain::Loaders::FileLoader)
        files = directory_loader.load
        p files.size
      end

      Knowlecule::Import.new(sources)
    end

  end # end cli class
end # end soundbot module

puts "hey"