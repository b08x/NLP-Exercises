#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  class Text < Item

    def initialize
    end

  end


end

# the algorithm gem provides this functionaity 
# and more!


class FileIterator
  def initialize(files)  
    @files = files    
    @keys = files.keys    
    @index = 0    
  end    
  
  def has_next?  
    @index < @keys.length    
  end    
  
  def next  
    key = @keys[@index]    
    file = @files[key]    
    @index += 1    
    { key: key, file: file }    
  end    
end  


# Example usage
# files = {
#   file1: "file1.txt",  
#   file2: "file2.txt",  
#   file3: "file3.txt"  
# }  
# => {:file1=>"file1.txt", :file2=>"file2.txt", :file3=>"file3.txt"}


# Processing file file1: file1.txt
# Processing file file2: file2.txt
# Processing file file3: file3.txt
# => nil
# [15] pry(main)> 
