#!/usr/bin/env ruby
# frozen_string_literal: false

require "drydock"
require "highline/import"

module Knowlecule
  class CLI
    extend Drydock

    default :welcome
    debug :on

    before do
      @hostname = `cat /etc/hostname`.strip
    end

    about "about"
    command :about do |_obj|
      puts "hey...this is what this is about!"
    end

    about "main menu"
    command :menu do |_obj|
      Soundbot::Menu.start
    end

    about "sampler"
    command :sampler do |_obj|
      Sampler.list
    end

    # about "load studio"
    # option :c, :close
    # command :studio do |_obj|
    #   if _obj.option["close"]
    #     Soundbot::Studio.close
    #   else
    #     Soundbot::Studio.start
    #     Soundbot::Studio.menu
    #   end
    # end

    # about "start osc server"
    # command :osc do |_obj|
    #   $logger.info "starting osc server"
    #   Daemons.run(File.join(File.dirname(__FILE__), 'osc.rb'), $daemon_options)
    # end

    about "import one or more files and/or folders"
    command :import do |obj|
      require "pathname"

      sources = obj.argv.map {|source| Pathname.new(source)}

      files = []
      sources.each do |source|
        unless source.realdirpath.exist?
          puts "#{source} not valid...exiting"; exit
        end
        if source.realdirpath.directory?
          files += Knowlecule::Util::Glob.documents(source.realdirpath)
        elsif source.realdirpath.file?
          files << source.realdirpath
        else
          puts "neither file nor directory, exiting"
        end
      end

      @files = files.map { |file| Item.new(file) }
    end

  end # end cli class
end # end soundbot module
