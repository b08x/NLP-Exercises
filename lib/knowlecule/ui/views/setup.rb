module Knowlecule
  module UI
    module Views
      class Setup < BaseView
        questions({
          path: {
            statement: 'What do you need?',
            options: [
              'docker',
              'database',
              'something else'
            ]
          }
        })
      end
    end
  end
end
