require File.dirname(__FILE__) + '/../generator_helpers'

class SimileTimelineGenerator < Rails::Generator::Base
  
  include GeneratorHelpers
  
  def self_dir ; File.dirname(__FILE__) ; end
  
  def manifest
    record do |m|
      m.directory 'public/javascripts'
      files_in(m, 'timeline_ajax', 'public/javascripts/')
      files_in(m, 'timeline_js', 'public/javascripts/')
      m.file 'timeline.js', 'public/javascripts/timeline.js'
      m.directory 'app/views/shared'
      m.file '_timeline.html.erb', 'app/views/shared/_timeline.html.erb'
      m.directory 'app/helpers'
      m.file 'timeline_heper.rb', 'app/helpers/timeline_helper.rb'
      m.readme 'README'
    end
  end

end