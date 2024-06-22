#!/usr/bin/env ruby

lib_dir = File.expand_path(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'parallel'

class Import
  attr_accessor :files

  def initialize(sources=[])
    files = []
    sources.each do |source|
      if source.realdirpath.directory?
        files += Glob.sounds(source.realdirpath)
      elsif source.realdirpath.file?
        files << source.realdirpath
      else
        puts "neither file nor directory, exiting"
      end
    end
      @files = files.map { |file| Item.new(file) }
  end

  def start
    total_files = @files.count

    Parallel.map(@files, progress: "Adding Files to Database", in_processes: 4) do |file|

      orginalPath = file.realdirpath.to_s

      begin
        unless AudioFiles.find(orginalPath: orginalPath).nil?
          if AudioFiles.find(orginalPath: orginalPath).exists?
            $logger.info "#{orginalPath} already exists, skipping import"
            next
          end
        end
      rescue ArgumentError => e
        $logger.info "#{file} #{e.message}"
      end

      parentFolder = file.realdirpath.relative_path_from($library).dirname.to_s
      basename = file.basename.sub(file.extname,"").to_s
      extension = file.extname

      info = SoxStuff.info(file)

      if extension == '.mp3'
        results = Soundbot::Command.tty("mp3val -f -si -nb #{orginalPath.shellescape}")
        unless results.nil?
          if results.match?("WARNING")
            puts "#{results}"
          end
        end
      end

      basename = basename.sub(/\.\d+$/,'')
      basename = basename.sub(/\s\(\d\)$/,'')

      begin
        AudioFiles.find_or_create(
          orginalPath: orginalPath,
          parentFolder: parentFolder,
          basename: basename,
          extension: extension,
          size: info[:file_size],
          duration: info[:length_s].to_f.round(2),
          channels: info[:channels].to_i,
          sampleRate: info[:sample_rate].to_i,
          format: info[:sample_encoding],
          bitDepth: info[:precision],
          rms: info[:rms_lev_db].split[0].to_f,
          rms_peak: info[:rms_pk_db].split[0].to_f,
          peak: info[:pk_lev_db].split[0].to_f,
          dcoffset: info[:dc_offset].split[0].to_f.round(4)
        )

        $logger.debug "added #{orginalPath}"
        puts "\n"

        rescue Sequel::ConstraintViolation => e
          $logger.debug "<#{orginalPath}> already exists in database\n#{e.message}"
        end

    end # of of parallel map
  end #end start method
end # end Import class
