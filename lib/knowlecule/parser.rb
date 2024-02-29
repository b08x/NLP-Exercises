#!/usr/bin/env ruby
# frozen_string_literal: true

require "aoororachain"

# Setup logger.
Aoororachain.logger = Logger.new($stdout)
Aoororachain.log_level = Aoororachain::LEVEL_DEBUG

# A DirectoryLoader points to a path and sets the glob for the files you want to load.
# A loader is also specified. FileLoader just opens and reads the file content.
# The RubyDocParser is set as well. This is optional in case you data is very nice and needs no pre-processing.

def loader(pathname,globtype,parser="general")



  directory_loader = Aoororachain::Loaders::DirectoryLoader.new(path: "#{pathname}", glob: "**/*.#{filetype}", loader: Aoororachain::Loaders::FileLoader, parser: parser)

end


`knowlecule import /home/b08x/Library/docs`




files = directory_loader.load
