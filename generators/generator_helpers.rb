module GeneratorHelpers

  def files_in(m, dir, top_dir = '')
    Dir["#{File.join(self_dir, 'templates', dir)}/*"].each do |file|

      m.directory "#{top_dir}#{dir}"

      if(File.directory?(file))
        files_in(m, "#{dir}/#{File.basename(file)}", top_dir)
      else
        m.file "#{dir}/#{File.basename(file)}", "#{top_dir}#{dir}/#{File.basename(file)}"
      end
    end
  end


end