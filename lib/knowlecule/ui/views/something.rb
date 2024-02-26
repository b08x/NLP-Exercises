module Knowlecule
  module UI
    module Views
      class Something < BaseView
        questions({
          something: { statement: 'Which something?' },
          something_representation: {
            statement: 'How do you wanna see it baby?',
            options: Commands::AvailableRepresentations.run
          }
        })

        def render
          # chord = Commands::GetRepresentationPrompt.run(params[:chord]).first
          Commands::GetRepresentationPrompt.run("hey hey", "ho ho")
        end

      end
    end
  end
end
