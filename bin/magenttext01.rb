#!/usr/bin/env ruby
# frozen_string_literal: true

lib_dir = File.expand_path(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'nano-bots'
require 'jongleur'
require 'redis'
require 'json'
require 'yaml'

require "dotenv"
Dotenv.load(File.join(__dir__, "..", "docker", ".env"))

require "utils/logging"

include Logging

class Jongleur::WorkerTask
  @@redis = Redis.new(host: "localhost", port: 6379, db: 15)
end

class WorkflowAgent
  def initialize(role, cartridge_file)
    @role = role
    @state = {}
    @bot = NanoBot.new(
      cartridge: cartridge_file
    )
  end

  def process(input)

    @bot.eval(input) do |content, fragment, finished, meta|
      @response = content unless content.nil?        
      # print fragment unless fragment.nil?
    end

    update_state(@response)
    @response
  end

  def save_state
    Jongleur::WorkerTask.class_variable_get(:@@redis).hset(
      Process.pid.to_s, 
      "agent:#{@role}", 
      @state.to_json
    )
  end

  def load_state
    state_json = Jongleur::WorkerTask.class_variable_get(:@@redis).hget(
      Process.pid.to_s, 
      "agent:#{@role}"
    )
    @state = JSON.parse(state_json) if state_json
  end

  private

  def update_state(response)
    @state[:last_response] = response
  end
end

class ResearcherTask < Jongleur::WorkerTask
  def execute
    begin
      agent = WorkflowAgent.new("researcher", "researcher_cartridge.yml")
      agent.load_state
      result = agent.process("Research on Advancements in Garden Gnome Technology")
      agent.save_state
      @@redis.set("research_result", result.to_json)
    rescue => e
      logger.error "Error in ResearcherTask: #{e.message}"
      raise
    end
  end
end

class WriterTask1 < Jongleur::WorkerTask
  def execute
    begin
      agent = WorkflowAgent.new("writer1", "writer_cartridge.yml")
      agent.load_state
      research_result = JSON.parse(@@redis.get("research_result"))
      article = agent.process("Write an article based on: #{research_result}")
      agent.save_state
      @@redis.rpush("articles", article)
    rescue => e
      logger.error "Error in WriterTask1: #{e.message}"
      raise
    end
  end
end

class WriterTask2 < Jongleur::WorkerTask
  def execute
    begin
      agent = WorkflowAgent.new("writer2", "writer_cartridge.yml")
      agent.load_state
      research_result = JSON.parse(@@redis.get("research_result"))
      article = agent.process("Write a fantasy-horror narrative based on: #{research_result}")
      agent.save_state
      @@redis.rpush("articles", article)
    rescue => e
      logger.error "Error in WriterTask2: #{e.message}"
      raise
    end
  end
end

class FinalizeTask < Jongleur::WorkerTask
  def execute
    begin
      agent = WorkflowAgent.new("finalizer", "finalizer_cartridge.yml")
      articles = @@redis.lrange("articles", 0, -1)
      final_result = agent.process("Summarize and finalize these articles: #{articles.join('\n\n')}")
      puts "Final Result:"
      puts final_result
    rescue => e
      logger.error "Error in FinalizeTask: #{e.message}"
      raise
    end
  end
end

class WorkflowOrchestrator
  def initialize
    @agents = {}
  end

  def add_agent(role, cartridge_file)
    @agents[role] = WorkflowAgent.new(role, cartridge_file)
  end

  def define_workflow(workflow_definition)
    Jongleur::API.add_task_graph(workflow_definition)
  end

  def run_workflow
    Jongleur::API.print_graph('/tmp')

    Jongleur::API.run do |on|
      on.completed do |task_matrix|
        puts "Workflow completed"
        puts task_matrix
      end
    end
  end
end

# Example usage
orchestrator = WorkflowOrchestrator.new
orchestrator.add_agent('researcher', 'researcher_cartridge.yml')
orchestrator.add_agent('writer1', 'writer_cartridge.yml')
orchestrator.add_agent('writer2', 'writer_cartridge.yml')
orchestrator.add_agent('finalizer', 'finalizer_cartridge.yml')

workflow_graph = {
  ResearcherTask: [:WriterTask1, :WriterTask2],
  WriterTask1: [:FinalizeTask],
  WriterTask2: [:FinalizeTask]
}

orchestrator.define_workflow(workflow_graph)
orchestrator.run_workflow