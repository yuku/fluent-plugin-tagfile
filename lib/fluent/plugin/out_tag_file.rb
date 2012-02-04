module Fluent
  class TagFileOutput < FileOutput
    Plugin.register_output('tag_file', self)

    def format(tag, time, record)
      tag_path = File.join(tag.split('.')[1..-1].concat(Time.at(time).strftime('%Y/%m/%d/%H').split('/')))
      time_str = @timef.format(time)
      "#{tag_path}|:|:|#{time_str}\t#{tag}\t#{record.to_json}\n"
    end

    def write(chunk)
      case @compress
      when nil
        suffix = ''
      when :gz
        suffix = '.gz'
      end

      data = chunk.read.split('|:|:|')
      dir = File.join(@path.split('/')[0...-1], data[0])
      data = data[1]

      i = 0
      begin
        path = "#{dir}/#{i}#{@path_suffix}#{suffix}"
        i += 1
      end while File.exist?(path)
      FileUtils.mkdir_p File.dirname(path)

      case @compress
      when nil
        File.open(path, 'a') {|f| f.write(data) }
      when :gz
        Zlib::GzipWriter.open(path) {|f| f.write(data) }
      end

      return path
    end
  end 
end
