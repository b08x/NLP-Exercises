#!/usr/bin/env ruby
# frozen_string_literal: true

require "tty-config"

CONFIG_HOME = ENV["CONFIG_HOME"]

module Knowlecule
  class Config
    attr_accessor :config

    def initialize
      load_config
      @config = TTY::Config.new
      @config.append_path(CONFIG_HOME)
      @config.read.to_h
    end

    private

    def load_config
      default_config = File.join(__dir__, "config.default.yml")

      unless Dir.exists?(CONFIG_HOME)
        FileUtils.mkdir(CONFIG_HOME)
        FileUtils.cp(default_config, File.join(CONFIG_HOME, "config.yml"))
      end

    end


  end
end

$config = Knowlecule::Config.new.config
$models = $config.fetch(:models)
