require File.dirname(__FILE__) + '/../generator_helpers'

class IopdDropdownGenerator < Rails::Generator::Base
  
  include GeneratorHelpers
  
  def manifest
    record do |m|
      m.directory 'app/views/shared'
      m.file '_ipod_dropdown.html.erb', 'app/views/shared/_ipod_dropdown.html.erb'
      m.directory 'app/helpers'
      m.file 'ipod_dropdown_helper', 'app/helpers/ipod_dropdown_helper'
      m.directory 'public/stylesheets'
      m.directory 'public/javascripts'
      files_in(m, 'ipod_menu', 'public/stylesheets/')
      m.file 'fg.menu.js', 'public/javascripts/fg.menu.js'
      m.file 'jquery-1.3.2.min.js', 'public/javascripts/jquery-1.3.2.min.js'
      m.readme 'README'
    end
  end

end