module Fluent
  class TagFileOutput < FileOutput
    Plugin.register_output('tag_file', self)

    def configure(conf)
      conf['buffer_path'] ||= File.join(conf['path'], 'buffer')

      super
    end

    def format(tag, time, record)
      tag_elems = tag.split('.')
      tag_elems.shift  # remove PREFIX
      dir = File.join(@path, *tag_elems)

      # @timef is assigned in FileOutput.configure
      time_str = @timef.format(time)

      [dir, "#{time_str}\t#{Yajl.dump(record)}\n"].to_msgpack
    end

    def write(chunk)
      case @compress
      when nil
        suffix = ''
      when :gz
        suffix = '.gz'
      end

      hash = {}
      chunk.msgpack_each do |(dir, data)|
        sym = dir.to_sym
        if hash.include?(sym)
          hash[sym] += data
        else
          hash[sym] = data
        end
      end

      hash.each do |dir, data|
        dir = File.join(dir.to_s, chunk.key)

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
end
