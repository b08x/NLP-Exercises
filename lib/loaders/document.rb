#!/usr/bin/env ruby
# frozen_string_literal: true

module Knowlecule
  class Text < Item

    def initialize
    end

  end


end


=> nil
[8] pry(main)> class FileIterator
[8] pry(main)*   def initialize(files)  
[8] pry(main)*     @files = files    
[8] pry(main)*     @keys = files.keys    
[8] pry(main)*     @index = 0    
[8] pry(main)*   end    
[8] pry(main)*   
[8] pry(main)*   def has_next?  
[8] pry(main)*     @index < @keys.length    
[8] pry(main)*   end    
[8] pry(main)*   
[8] pry(main)*   def next  
[8] pry(main)*     key = @keys[@index]    
[8] pry(main)*     file = @files[key]    
[8] pry(main)*     @index += 1    
[8] pry(main)*     { key: key, file: file }    
[8] pry(main)*   end    
[8] pry(main)* end  
=> :next
[9] pry(main)> 
[10] pry(main)> # Example usage
[11] pry(main)> files = {
[11] pry(main)*   file1: "file1.txt",  
[11] pry(main)*   file2: "file2.txt",  
[11] pry(main)*   file3: "file3.txt"  
[11] pry(main)* }  
=> {:file1=>"file1.txt", :file2=>"file2.txt", :file3=>"file3.txt"}
[12] pry(main)> iterator = FileIterator.new(files)
=> #<FileIterator:0x000070161adfc4d8 @files={:file1=>"file1.txt", :file2=>"file2.txt", :file3=>"file3.txt"}, @index=0, @keys=[:file1, :file2, :file3]>
[13] pry(main)> 
[14] pry(main)> while iterator.has_next?
[14] pry(main)*   file_info = iterator.next  
[14] pry(main)*   key = file_info[:key]  
[14] pry(main)*   file = file_info[:file]  
[14] pry(main)*   puts "Processing file #{key}: #{file}"  
[14] pry(main)*   # Do something with the file  
[14] pry(main)* end  
Processing file file1: file1.txt
Processing file file2: file2.txt
Processing file file3: file3.txt
=> nil
[15] pry(main)> 
