module GoogleMapHelper
  
  def gmap_includes
    result = '<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>'
    result << javascript_include_tag('google_map')
    result
  end
  
  # Create a google map for the given coordinates. You may pass options both for
  # the map itself and for the container element. If no other id is specified,
  # the container will be a <div> with the id 'gmap_canvas'
  #
  # == Examples:
  #
  #  gmap(100, 100, :zoom => 3) # center on this coordinates
  #  gmap(100, 100, :map_type => :satellite)
  #  gmap 100, 100 :zoom => 8, :navigation_control_options => { :position => 'TOP_RIGHT', :style => 'SMALL' }
  #  gmap 100, 100, { :zoom => 12 }, { :id => 'gmap_elemet' }
  def gmap(latitude, longitude, map_options = {}, html_options = {})
    html_options['id'] ||= 'gmap_canvas'
    html_options.stringify_keys!
    real_map_options = {}
    # Make the keys "javscript_style"
    map_options.each_pair do |k,v| 
      new_key = k.to_s.camelize.gsub(/^./) { |first| first.downcase }
      real_map_options[new_key] = v 
    end
    render(:partial => 'shared/google_map', :locals => { :latitude => h(latitude), :longitude => h(longitude), :html_options => html_options, :map_options => real_map_options })
  end
  
  # creates a google map for the given source, if the source has long and lat properties in wgs84 format
  def gmap_for(source, map_options = {}, html_options = {})
    lat = source['http://www.w3.org/2003/01/geo/wgs84_pos#lat'].first
    long = source['http://www.w3.org/2003/01/geo/wgs84_pos#long'].first
    raise(ArgumentError, "This source doesn't contain geodata.") unless(lat && long)
    gmap(lat, long, map_options, html_options)
  end

  
end