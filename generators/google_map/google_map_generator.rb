require File.dirname(__FILE__) + '/../generator_helpers'

class GoogleMapGenerator < Rails::Generator::Base
  
  include GeneratorHelpers
  
  def self_dir ; File.dirname(__FILE__) ; end
  
  def manifest
    record do |m|
      m.directory 'app/views/shared'
      m.file '_google_map.html.erb', 'app/views/shared/_google_map.html.erb'
      m.directory 'app/helpers'
      m.file 'google_map_helper.rb', 'app/helpers/google_map_helper.rb'
      m.directory 'public/javascripts'
      m.file 'jquery-1.3.2.min.js', 'public/javascripts/jquery-1.3.2.min.js'
      m.file 'google_map.js', 'public/javascripts/google_map.js'
      m.readme 'README'
    end
  end

end