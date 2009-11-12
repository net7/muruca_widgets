require File.dirname(__FILE__) + '/../generator_helpers'

class ColorboxGenerator < Rails::Generator::Base
  
  include GeneratorHelpers
  
  def self_dir ; File.dirname(__FILE__) ; end
  
  def manifest
    record do |m|
      files_in(m, 'colorbox', 'public/stylesheets/')
      m.directory 'app/views/shared'
      m.file '_colorbox.html.erb', 'app/views/shared/_colorbox.html.erb'
      m.directory 'public/javascripts'
      m.file 'jquery-1.3.2.min.js', 'public/javascripts/jquery-1.3.2.min.js'
      m.readme 'README'
    end
  end

end