#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "tty-config"

CONFIG_HOME = File.join(Dir.home, ".config")

module Knowlecule
  class Config
    include Logging
    attr_accessor :config

    def initialize
      load_config
      @config = TTY::Config.new
      @config.append_path(CONFIG_HOME)
      @config.read.to_h
    end

    private

    def load_config
      default_config = File.join(File.expand_path("..", __dir__), "config.default.yml")

      unless Dir.exist?(CONFIG_HOME)
        logger.debug("creating config folder")
        FileUtils.mkdir(CONFIG_HOME)
      end

      unless File.exist?(File.join(CONFIG_HOME, "config.yml"))
        logger.debug("installing default config to #{CONFIG_HOME}")
        FileUtils.cp(default_config, File.join(CONFIG_HOME, "config.yml"))
      end
    end
  end
end

# $config = Knowlecule::Config.new.config
# $models = $config.fetch(:models)
