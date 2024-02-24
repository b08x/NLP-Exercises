require "thor"

module Knowlecule
  class CLI < Thor
    extend ThorExt::Start

    map %w[-v --version] => "version"

    desc "version", "Display knowlecule version", hide: true
    def version
      say "knowlecule/#{VERSION} #{RUBY_DESCRIPTION}"
    end
  end
end
