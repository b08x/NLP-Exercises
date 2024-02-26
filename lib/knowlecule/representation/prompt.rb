# frozen_string_literal: true

module Knowlecule
  module Representation
    class Prompt
      class Example
        attr_reader :system, :user

        def initialize(system, user)
          @system = string
          @use = user
        end

        def context
          puts "context"
        end

        def other
          puts "other"
        end

        # alias note pitch_class
      end
    end
  end
end