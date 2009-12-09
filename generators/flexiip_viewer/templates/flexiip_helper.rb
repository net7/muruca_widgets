module FlexiipHelper

  # Inserts the Flexiip viewer into the page. This method takes an IIP data object (from which the iip request
  # url will be generated), and optionally an Hash with the options for the containing <div> element.
  #
  # == Example
  #
  #  iip_flahs_viewer(flash_data_object, :class => 'viewer', :height => '100%')
  def flexiip_viewer(iip_data, title = '', html_options = {})
    raise(ArgumentError, 'Must pass an iip data object here') unless(iip_data.is_a?(TaliaCore::DataTypes::IipData))
    html_options.to_options!
    html_options[:class] ||= 'iipviewer'
    render :partial => 'shared/flexiip_viewer', :locals => {
      :image_path => h(iip_data.get_iip_root_file_path),
      :options => html_options,
      :title => h(title)
    }
  end

end