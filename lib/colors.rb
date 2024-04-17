#!/usr/bin/env ruby
# frozen_string_literal: true

lib_dir = File.expand_path(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

module Laudllm

  module Colors
    module_function

    def set(style)
      case style
      when 'light', 'l'
        light_colors
      when 'mono', 'm'
        mono_colors
      when 'paper', 'p'
        paper_colors
      else
        default_colors
      end
    end

    def default_colors
      @header = '#fabd2f'
      @bg = '#1d2021'
      @bgp = '#504945'
      @fg = '#fe8019'
      @fgp = '#fabd2f'
      @previewbg = '#1d2001'
      @previewfg = '#b8bb26'
      @info = '#83a598'
      @border = '#fb4934'
      @spinner = '#fe8019'
      @hl = '#83a598'
      @hlp = '#8ec07c'
      @pointer = '#fb4934'
      @prompt = '#fb4934'
      @gutter = '#3c3836'
      @marker = '#fb4934'
    end
  
    def light_colors
      @header = '#fe5009'
      @bg = '#ebdbb2'
      @bgp = '#d5c4a1'
      @fg = '#000000'
      @fgp = '#504945'
      @previewbg = '#8ec07c'
      @previewfg = '#000000'
      @info = '#665c54'
      @border = '#d3869b'
      @spinner = '#fe8019'
      @hl = '#1102aa'
      @hlp = '#1102fb'
      @pointer = '#fe5009'
      @prompt = '#b8bb26'
      @gutter = '#8ec07c'
      @marker = '#1f92fb'
    end

    def mono_colors
      @header = '#a1efe4'
      @bg = '#272822'
      @bgp = '#223aa2'
      @fg = '#a6e22e'
      @fgp = '#fc6633'
      @previewbg = '#125849'
      @previewfg = '#fc6633'
      @info = '#f5f4f1'
      @border = '#a1efe4'
      @spinner = '#f4bf75'
      @hl = '#66d9ef'
      @hlp = '#66d9af'
      @pointer = '#ae81ff'
      @prompt = '#f8a8f2'
      @gutter = '#383830'
      @marker = '#fc6633'
    end

    def paper_colors
      @header = '#d7875f'
      @bg = '#1c1c1c'
      @bgp = '#000a58'
      # 5f8787
      @fg = '#5fafd7'
      @fgp = '#1ae00f'
      @previewbg = '#585858'
      @previewfg = '#ffaf00'
      @info = '#afd700'
      @border = '#af005f'
      @spinner = '#00afaf'
      @hl = '#d7af5f'
      @hlp = '#f9cf50'
      @pointer = '#af005f'
      @prompt = '#808080'
      @gutter = '#4c8787'
      @marker = '#af005f'
    end
  
  end




end