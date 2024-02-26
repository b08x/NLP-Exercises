module Knowlecule
  module UI
    module Views
      class Index < BaseView
        questions({
          path: {
            statement: "Welcome to Knowlecule #{Knowlecule::VERSION}",
            options: %w[setup import process search something exit]
          }
        })
      end
    end
  end
end
