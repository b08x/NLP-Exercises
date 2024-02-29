#!/usr/bin/env ruby
# frozen_string_literal: true

require "tty-config"

CONFIG_HOME = File.join(ENV.fetch('HOME'), ".config")

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
      default_config = File.join(File.expand_path("../../", __FILE__), "config.default.yml")

      unless Dir.exists?(CONFIG_HOME)
        Knowlecule::UI.say(:ok, "setting config")
        FileUtils.mkdir(CONFIG_HOME)
      end

      unless File.exist?(File.join(CONFIG_HOME, "config.yml"))
        FileUtils.cp(default_config, File.join(CONFIG_HOME, "config.yml"))
      end

    end
  end
end

$config = Knowlecule::Config.new.config
$models = $config.fetch(:models)
