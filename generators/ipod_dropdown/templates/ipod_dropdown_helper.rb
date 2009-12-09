module IpodDropdownHelper

  # Helper class to build the data list
  class ListWriter

    # Create the writer with the given elements. The add_parents
    # option will show the parent elements as a specially-styled first entry
    # of their child list.
    def initialize(elements, add_parents, &block)
      @elements = elements
      @block = block
      @add_parents = add_parents
    end
    attr_reader :elements, :block, :add_parents

    # Make the list for the dropdown
    def make_list
      raise(ArgumentError, "Must pass rendering block here.") unless(block)
      if(elements.is_a?(Hash))
        tree_list
      else
        flat_list
      end
    end  

    private

    # Rendering for a flat list (just an array)
    def flat_list
      return '' if(elements.empty?)
      result = "<ul>\n"
      result << flat_items_for(elements)
      result << "</ul>\n"
      result
    end

    def flat_items_for(my_elements)
      result = ''
      my_elements.each { |element|  result << '<li>' << block.call(element) << "</li>\n" }
      result
    end

    # Render a nested ul list from a tree-like hash structure (where each hash key is a node,
    # and the value containing the children)
    def tree_list
      result = "<ul>\n"
      elements.each { |parent, children| result << subtree_list_for(parent, children) }
      result << "</ul>\n"
      result
    end

    def subtree_list_for(parent, children)
      result = ''
      result << '<li>' << block.call(parent) << "\n"
      if(!children.empty?)
        result << "<ul>\n"
        result << '<li class="ui-state-highlight ui-corner-all">' << block.call(parent) << "</li>\n" if(add_parents)
        if(children.is_a?(Array))
          result << flat_items_for(children)
        else
          children.each { |child, progeny| result << subtree_list_for(child, progeny) }
        end
        result << "</ul>\n"
      end
      result << "</li>\n"
      result
    end  

  end


  # Includes all the javascript and styles needed for the ipod dropdown
  # 
  # Note that this does *not* include the jquery framework which is needed
  # for the widget!
  def fg_menu_includes
    result = javascript_include_tag('fg.menu')
    result << javascript_include_tag('ipod_menu')
    result << stylesheet_link_tag('ipod-menu/fg.menu.css')
    result << stylesheet_link_tag('ipod-menu/theme/ui.all.css')
    result
  end

  # Place an ipod-menu-like dropdown many with multiple levels
  # This must contain a block to render each of the list elements. The block should
  # create an a tag for each of the elements in the list.
  #
  # The only option recognized by the helper itself is "include_parents". If set to
  # true, it will add the "parent node" of each child list as a specially-styled element
  # on the child list.
  #
  # All other options are passed to the fg_menu javascript.
  #
  # == Constructing Elements
  #
  # The elements must either be a tree-like hash construct of the form 
  #
  #  {root_a => {child1 => {}, child2 => {}}, root_b => {}}
  # 
  # or a flat array:
  #
  #  ['first', 'second', 'third']
  #
  # You can also mix both forms:
  #
  #  {root_a => {child1 => ['first', 'second'], child2 => {}}, root_b => {}}
  #
  # Each of the elements will be passed to the rendering block of this method. It's also
  # possible to pass arrays as elements (which will then expand to multiple parameters
  # in the block):
  #
  #  <%= ipod_dropdown('Related', [['first', 'http://www.firstlink.com/'], ['second', 'http://www.secondlink.it']]) { |el, lnk| link_to(el, lnk) } %>
  #
  # = Known issues
  #
  # A the moment, the block must be inside the ERB tag, capturing of embedded template code doesn't work 
  # properly (yet)
  def ipod_dropdown(title, elements, fg_menu_options = {}, &block)
    @dropdown_count ||= 0
    @dropdown_count += 1
    fg_menu_options.stringify_keys!
    fg_menu_options['unique_id'] = @dropdown_count.to_s
    add_parents = !fg_menu_options.delete('include_parents').blank?
    raise(ArgumentError, "Must pass rendering block here.") unless(block)
    writer = ListWriter.new(elements, add_parents, &block)
    render(:partial => 'shared/ipod_dropdown', :locals => { :button_text => h(title), :element_list => writer.make_list, :pod_options => fg_menu_options, :unique_id => @dropdown_count.to_s })
  end

end