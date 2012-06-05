module Fluent
  class TagFileOutput < FileOutput
    Plugin.register_output('tag_file', self)

    # @timef is assigned in FileOutput.configure method.
    #
    # ==== Args
    # tag :: "PREFIX.path.to.dir"
    def format(tag, time, record)
      time_str = @timef.format(time)
      "#{time_str}\t#{tag}\t#{record.to_json}\n"
    end

    def write(chunk)
      data = chunk.read
      time_str, tag, record = data.split("\t")

      elems = tag.split('.')
      elems.shift  # remove prefix
      elems.push(time_str)

      # *Attention* @path points buffer dir not log directory
      # @path    :: /var/log/fluent/buffer
      # root_dir :: /var/log/fluent
      # dir      :: /var/log/fluent/path/to/dir/%Y/%m/%d/%H
      root_dir = @path.split('/')[0...-1]
      dir = File.join(root_dir, *elems)

      case @compress
      when nil
        suffix = ''
      when :gz
        suffix = '.gz'
      end

      i = 0
      begin
        path = File.join(dir, "#{i}#{@path_suffix}#{suffix}")
        i += 1
      end while File.exist?(path)
      FileUtils.mkdir_p dir

      case @compress
      when nil
        File.open(path, 'a') {|f| f.write(data) }
      when :gz
        Zlib::GzipWriter.open(path) {|f| f.write(data) }
      end

      return path  # for test
    end
  end
end
