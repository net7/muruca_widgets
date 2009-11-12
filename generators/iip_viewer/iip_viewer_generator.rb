class IipViewerGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory 'public'
      m.file 'fliipish.swf', 'public/fliipish.swf'
      m.directory 'public/javascripts'
      m.file 'iip_flashclient.js', 'public/javascripts/iip_flashclient.js'
      m.file 'swfobject.js', 'public/javascripts/swfobject.js'
      m.directory 'app/helpers'
      m.file 'iip_helper.rb', 'app/helpers/iip_helper.rb'
      m.directory 'app/views/shared'
      m.file '_iip_flash_viewer.html.erb', 'app/views/shared/_iip_flash_viewer.html.erb'
      m.readme 'README'
    end
  end

end