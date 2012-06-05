module Fluent
  class TagFileOutput < FileOutput
    Plugin.register_output('tag_file', self)

    def configure(conf)
      conf['buffer_path'] ||= File.join(conf['path'], 'buffer')

      super

      @timesf = TimeFormatter.new(@time_slice_format, @localtime)
    end

    # ==== Args
    # tag    :: "PREFIX.path.to.dir"
    # time   ::
    # record ::
    def format(tag, time, record)
      tag_elems = tag.split('.')
      tag_elems.shift  # remove PREFIX
      tag_elems.push(@timesf.format(time))
      dir = File.join(@path, *tag_elems)

      # @timef is assigned in FileOutput.configure
      time_str = @timef.format(time)

      "#{dir}\t#{time_str}\t#{Yajl.dump(record)}"
    end

    def write(chunk)
      data = chunk.read
      pos  = data.index("\t")
      dir  = data[0...pos]
      data = data[pos+1..-1] + "\n"

      case @compress
      when nil
        suffix = ''
      when :gz
        suffix = '.gz'
      end

      i = 0
      begin
        path = File.join(dir, "#{i}.log#{suffix}")
        i += 1
      end while File.exist?(path)
      FileUtils.mkdir_p dir

      case @compress
      when nil
        File.open(path, 'a') {|f| f.write(data) }
      when :gz
        Zlib::GzipWriter.open(path) {|f| f.write(data) }
      end
    end
  end
end
