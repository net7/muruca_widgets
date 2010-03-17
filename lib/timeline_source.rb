require 'talia_core'

# Creates the json data for a Simile timeline.
class TimelineSource
  
  
  # Create a new timeline source. There are several ways to fill this with data:
  #
  # [*raw_data*] The most straightforward method is to pass the :raw_data option which 
  #              must contain an array containing each 
  #              event on the timeline as a hash. Each event must at least contain the
  #              :start (start date), :title (Event title). Other than that, all,
  #              options that are valid for the simile timeline events will be accepted.
  #
  # [*sources*] The :sources option must contain a list of ActiveSource objects. 
  #             By default this will try to take the dcns:date property from all objects.
  #
  # [*source_finder*] Alternatively, you may pass the :source_finder option. This option should
  #                   contain a hash that will be passed into ActiveSource.find(:all)
  #
  # Other options that can be used to configure the working of the timeline
  # data source are:
  #
  # [*start_property*] Only valid with the :sources or :source_finder option. 
  #                    The class will try to retrieve the start date from this property. If an
  #                    ISO 8601 duration is found in the field a duration event is created (unless
  #                    an :end_property had been explicitly set). [default: dcns:date]
  #
  # [*end_property*] Take the end date of each event from this property. This will disable the
  #                  automatic handling of ISO 8601 durations (see :start_property)
  # 
  # [*title_property*] Take the event title from this property. If the title is not found, the
  #                    system will try the dcns:label property and if that fails use the
  #                    local part of the source URL. This is only valid with the :sources or
  #                    :source_finder options. [default: dcns:title]
  #
  # [*description_property*] Take the description of the event from this field. If not found,
  #                          the title value is used. This is only valid with the :sources or
  #                          :source_finder options. [default: dcns:abstract]
  #
  # [*link_property*] Property to take the link from. By default a link to the element's own URL is created.
  #                   This is only valid with the :sources or :source_finder options. 
  #
  # [*color*] Default color entry for the events. [default: 'blue']
  #
  # [*text_color*] Default text color for the events [default: 'black']
  #
  # [*start_year*] Year that the timeline starts in. If not given, this will automatically be
  #                calculated from the dataset
  #
  # [*final_year*] Last year of the timeline. See :start_year
  def initialize(options)
    @events = []
    @options = process_options(options)
    
    if(@options[:sources])
      initialize_from_sources(options[:sources])
    elsif(@options[:source_finder])
      sources = TaliaCore::ActiveSource.find(:all, @options[:source_finder])
      initialize_from_sources(sources)
    else
      initialize_from_data(@options[:raw_data])
    end
    @first_year = @options[:start_year] if(@options[:start_year])
    @last_year = @options[:final_year] if(@options[:final_year])
  end
  
  def first_year
    (@first_year || '1900').to_i
  end
  
  def last_year
    (@last_year || '2000').to_i
  end
  
  def timeline_data
    {
      :dateTimeFormat => 'iso8601',
      :events => @events
    }.to_json
  end
  
  # Get the iso8601 string for the date
  def self.to_iso8601(date)
    return nil unless(date)
    date.strftime('%Y-%m-%dT%H:%M:%SZ')
  end
  
  def empty?
    @events.empty?
  end
  
  private
  
  # Check the options and set them to the default values if necessary
  def process_options(options)
    options.to_options!
    options[:dateTimeFormat] ||= 'iso8601'
    # Check if we have one data source option given
    exactly_one_source = (options[:sources] != nil) ^ (options[:source_finder] != nil) ^ (options[:raw_data] != nil)
    # We could also all three options given - there should be at least one false, d'oh
    exactly_one_source = (exactly_one_source && (!options[:sources] || !options[:source_finder]))
    raise(ArgumentError, "Must give exactly one of :raw_data, :sources or :source_finder") unless(exactly_one_source)
    # Check - we don't want those options for :raw_data
    if(options[:raw_data])
      illegal_properties = (options[:start_property] || options[:end_property] || options[:title_property] || options[:description_property] || options[:link_property])
      raise(ArgumentError, "Illegal options: Must not set property options for :raw_data") if(illegal_properties)
    else
      # Otherwise we go with the default if necessary
      options[:start_property] ||= N::DCNS.date
      options[:title_property] ||= N::DCNS.title
      options[:description_property] ||= N::DCNS.abstract
    end
    # More defaults
    options[:color] ||= 'blue'
    options[:text_color] ||= 'black'
    options
  end
  
  # Initializes the data from a pre-existing data array. This mainly converts the dates
  # and fills in some fields automatically if they don't exist
  def initialize_from_data(data)
    data.each do |data_item|
      raise(ArgumentError, "Illegal element in data #{data_item.inspect}") unless(data.is_a?(Hash))
      data_item.to_options!
      raise(ArgumetnError, "Incomplete data element #{data_item.inspect}") unless(data_item[:start] && data_item[:title])
      # Fill the start and end dates with a normlized iso8106 version of the existing date(s)
      start_date, end_date = process_timestamp(data_item[:start])
      end_date = process_timestamp(data_item[:end]).first if(data_item[:end])
      data_item[:start], data_item[:end] = to_iso8601(start_date), to_iso8601(end_date)
      update_first_last_year([start_date, end_date]) # Also set the first/last year to a new value
      data_item[:duration_event] ||= true unless(data_item[:end]) # We have a duration if we have an end date
      # Auto-fill some other data elements if necessary
      data_item[:description] ||= data_item[:title]
      data_item[:color] ||= @options[:color]
      data_item[:text_color] ||= @options[:text_color]
      @items << data_item
    end
  end
  
  # Reads the data properties from the sources and converts them into a hash that
  # can be fed into the timeline widget
  def initialize_from_sources(sources)
    sources = [sources] unless(sources.is_a?(Array))
    
    start_predicate = @options[:start_property]
    end_predicate = @options[:end_property]
    
    
    first_year = nil
    last_year = nil

    # Cycle through the sources
    sources.each do |src|
      # Ignore all sources that do not have a timestamp
      next if((stamp = src[start_predicate].first).blank?)
      new_event = {}
      
      # Fill the start and end date fields
      dates = process_timestamp(stamp)
      # Overwrite the second date if we have a predefined "end" field
      dates[1] = process_timestamp(src[end_predicate]).first if(end_predicate)
      new_event[:start], new_event[:end] = dates.collect { |d| to_iso8601(d) }

      update_first_last_year(dates)
      
      # Fill the title/description fields
      new_event[:title] = src[@options[:title_property]].first || src[N::RDFS.label].first || N::URI.new(src.uri).to_name_s
      new_event[:description] = src[@options[:description_property]].first || new_event[:title]
      # new_event['image'] = ''
      # The link field may either be filled from a property, or with a link to the element itself (default)
      new_event[:link] = if(@options[:link_property])
          src[@options[:link_property]].first || ''
        else
          if((uri = src.to_uri).local?)
            '/' << uri.local_name
          else
            uri.to_s
          end
        end
      # We have a duration event if we have a non-nil end date
      new_event[:duration_event] = true unless(new_event[:end])
      # new_event[:icon] = 'red_circle.png'
      # Colors as defined in the options
      new_event[:color] = @options[:color]
      new_event[:textColor] = @options[:text_color]
      
      new_event.delete(:end) unless(new_event[:end])
      @events << new_event
    end
  end
  
  # Update the first/last year count on this data source
  def update_first_last_year(dates)
    first_year = dates.first.year
    last_year = (dates.last ? dates.last : dates.first).year
    
    @first_year ||= first_year
    @last_year ||= (last_year || first_year)
    @first_year = first_year if(first_year && first_year < @first_year)
    @last_year = last_year if(last_year && last_year > @last_year)
  end
  
  # This processes the given timestamp value and returns an array 
  # of either one or two formatted fields, depending 
  def process_timestamp(value)
    return nil unless(value)
    values = value.split('/')
    result = [ Date.parse(values.first) ]
    result << Date.parse(values.last) if(values.size > 1)
    result
  end
  
  def to_iso8601(date)
    TimelineSource.to_iso8601(date)
  end
  
  
end