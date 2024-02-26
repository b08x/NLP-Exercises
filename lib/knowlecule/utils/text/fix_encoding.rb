#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  module Util
    module_function

    # force an encoding and replace marks with nothing
    def fix_encoding(input)
      input.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
    end
  end
end
