class FlexiipViewerGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory 'public'
      m.file 'flexiip.swf', 'public/flexiip.swf'
      m.directory 'app/helpers'
      m.file 'flexiip_helper.rb', 'app/helpers/flexiip_helper.rb'
      m.directory 'app/views/shared'
      m.file '_flexiip_viewer.html.erb', 'app/views/shared/_flexiip_viewer.html.erb'
      m.directory 'public'
      m.file 'config.default.xml', 'public/config.default.xml'
      m.readme 'README'
    end
  end

end