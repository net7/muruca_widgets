require File.dirname(__FILE__) + '/../generator_helpers'

class IpodDropdownGenerator < Rails::Generator::Base
  
  include GeneratorHelpers
  
  def self_dir ; File.dirname(__FILE__) ; end
  
  def manifest
    record do |m|
      m.directory 'app/views/shared'
      m.file '_ipod_dropdown.html.erb', 'app/views/shared/_ipod_dropdown.html.erb'
      m.directory 'app/helpers'
      m.file 'ipod_dropdown_helper.rb', 'app/helpers/ipod_dropdown_helper.rb'
      m.directory 'public/stylesheets'
      m.directory 'public/javascripts'
      files_in(m, 'ipod-menu', 'public/stylesheets/')
      m.file 'fg.menu.js', 'public/javascripts/fg.menu.js'
      m.file 'jquery-1.3.2.min.js', 'public/javascripts/jquery-1.3.2.min.js'
      m.file 'ipod_menu.js', 'public/javascripts/ipod_menu.js'
      m.readme 'README'
    end
  end

end