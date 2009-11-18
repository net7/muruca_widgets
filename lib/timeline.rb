require 'json'
require 'timeline_source'

# Contains all the data and settings for a single Simile timeline
class Timeline
  
  # The main options that can be given to the timeline are 
  #
  # [*config*] - The configuration for timeline, including the bands configuration.
  #              This will be directly passed on to timline.js, see there for more
  #              documentation. If no :bands option is given, a default band
  #              is created for the timeline.
  # [*data*] - A TimelineSource object containing the data for this timeline OR a 
  #            hash with the options to create the TimelineSource
  def initialize(options)
    raise(ArgumentError, 'Expecting an option hash here.') unless(options.is_a?(Hash))
    options.to_options!
    raise(ArgumentError, 'Expecting some data here') unless(options[:data])
    raise(ArgumentError, 'Expecting the configuration here') unless(options[:config])
    
    if(options[:data].is_a?(TimelineSource))
      @data = options[:data]
    else
      @data = TimelineSource.new(options[:data])
    end
    
    @config = options[:config].to_options 
    @config[:startDate] ||= year_to_iso8601(@data.first_year) if(@data.first_year)
    @config[:stopDate] ||= year_to_iso8601(@data.last_year) if(@data.last_year)
    @default_date ||= year_to_iso8601(@data.first_year + ((@data.last_year - @data.first_year) / 2)) if(@data.first_year && @data.last_year)
    @config[:bands] ||= default_band
  end
  
  def timeline_config
    @config.to_json
  end
  
  def timeline_data
    @data.timeline_data
  end
  
  private
  
  def year_to_iso8601(year)
    year = year.to_i
    to_iso8601(Date.ordinal(year))
  end
  
  def to_iso8601(date)
    TimelineSource.to_iso8601(date)
  end
  
  def default_band
    [{
        :width => 70,
        :intervalUnit => 'DECADE',
        :intervalPixels => 100,
        :date => @default_date || '1900-01-01',
        :layout => 'original'
      }]
  end
  
end