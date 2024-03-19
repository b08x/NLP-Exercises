#!/usr/bin/env ruby
# frozen_string_literal: true

module Socrates
module Logger
  module_function

  require "logger"

  LOG_DIR = File.expand_path('log')
  LOG_LEVEL = Logger::DEBUG
  LOG_MAX_SIZE = 6_145_728
  LOG_MAX_FILES = 10

  @loggers = {}

  def logger
    classname = self.class.name
    methodname = caller[0][/`([^']*)'/, 1]
    @logger ||= Logging.logger_for(classname, methodname)
    @logger.progname = "#{classname}\##{methodname}"
    @logger
  end

  class << self
    def log_level
      Logger::DEBUG
    end

    def logger_for(classname, methodname)
      @loggers[classname] ||= default(classname, methodname)
    end

    def default(_classname, _methodname)
      @default ||= begin
        current_date = Time.now.strftime("%Y-%m-%d")
        log_file = File.join(LOG_DIR, "knowlecule-#{current_date}.log")
        logger = Logger.new(log_file, LOG_MAX_FILES, LOG_MAX_SIZE)
        logger.level = log_level
        logger
      end
    end
    # def default(_classname, _methodname)
    #   @default ||= begin
    #     logger       = new($stdout)
    #     logger.level = Logger::WARN
    #     logger
    #   end
    # end

  end
end
end
