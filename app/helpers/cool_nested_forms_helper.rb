module CoolNestedFormsHelper
  ## entries_container ##
  # arguments
  # - builder: a FormBuilder Object obtained from form_with or form_for
  # - association: a model class i.e. MyTask
  # - current_entries: all the current entries for the parent i.e. a Form.tasks
  # - options: hash of override options
  #   - partial: name of the erb partial to use as a tempalte for the existing entries
  #   - id: ID to be used in for the container
  #   - plurilized: the plural version of the model name
  #   - singularized: the singular version of the model name
  #   - parent_singularized: the name of the parent record. used for generating the entry's container id
  #   - parent_id: the id of the parent record. used for generating the entry's container id
  #   - class: a string with any css class names to be used for styling
  #   - style: a string with any css styles
  #   - tag: override the returned tag
  def entries_container(builder,association,current_entries, options = {})
    # initialize options
    options[:partial] ||= "#{association.name.underscore}_edit"
    options[:id] ||= association.name.underscore.pluralize
    options[:pluralized] ||= association.name.underscore.pluralize
    options[:singularized] ||= association.name.underscore
    options[:parent_singularized] ||= builder.object.class.name.underscore
    options[:parent_id] ||= builder.object.id.to_s
    options[:class] ||= ''
    options[:style] ||= ''
    options[:tag] ||= :div

    # render all the current entries
    output = builder.fields_for(options[:pluralized], current_entries) do |assoc_builder|
      id = "#{options[:parent_singularized]}_#{options[:parent_id]}_#{options[:singularized]}_#{assoc_builder.object.id}"
      render options[:partial], :builder => assoc_builder, :id => id
    end

    return content_tag(
      options[:tag],
      output.html_safe,
      :style => options[:style],
      :class => options[:class],
      :id => options[:id]
    )
  end
  ## new_entry_template ##
  # arguments
  # - builder: a FormBuilder Object obtained from form_with or form_for
  # - association: a model class i.e. MyTask
  # - options: hash of override options
  #   - partial: name of the erb partial to use as a tempalte
  #   - id: ID to be used in for the container
  #   - plurilized: the plural version of the model name
  #   - js_template_name: name for the javascript variable generated by this method ( useful when there are multiple nested associations)
  #   - children: an array with childre association options for nested association of a nested association
  def new_entry_template(builder,association, options = {})
    # initialize options
    options[:partial] ||= "#{association.name.underscore}_new"
    options[:id] ||= "#{association.name.underscore}_[tempid]"
    options[:pluralized] ||= association.name.underscore.pluralize
    options[:js_template_name] ||= association.name.underscore.pluralize
    options[:children] ||= []

    # children output
    children_output = ''
    # render the template using the form builder object and the association
    output = builder.fields_for(options[:pluralized],association.new, :child_index => "new_#{options[:pluralized]}") do |assoc_builder|

      # render each children
      options[:children].each do |child|
        children_output += new_entry_template(assoc_builder,child[:association],child)
      end

      # render erb partial
      render(:partial=>options[:partial],:locals =>{:builder => assoc_builder, :id => options[:id] })
    end

    # remove any new line characters
    output = output.gsub( /\r?\n|\r/, ' ')

    # create the script tag that will be output to the page
    script_tag = "<script> var #{options[:js_template_name]} = '#{output}'; </script>"

    # add children_output
    script_tag += children_output
    # return the output as html safe
    return script_tag.html_safe
  end

  ## new_entry_button ##
  # arguments
  # - name: A string to be displayed as the button text
  # - association: a model class i.e. MyTask
  # - target: a html tag ID where the button will be attached
  # - options: hash of override options
  #   - plurilized: the plural version of the model name
  #   - js_template_name: name for the javascript variable generated by this method ( useful when there are multiple nested associations)
  #   - class: a string with any css class names to be used for styling
  #   - style: a string with any css styles
  #   - child_js_template_names: an array with any children js template names.
  #     every time a nested association that contains other nested associations is added,
  #     a button to add a child entry is added to the new entry
  #   - tag: override the returned tag
  #   - tag_content: override the returned tag content
  def new_entry_button(name, association, options = {})
    options[:pluralized] ||= association.name.underscore.pluralize
    options[:js_template_name] ||= association.name.underscore.pluralize
    options[:class] ||= ""
    options[:style] ||= ""
    options[:child_js_template_names] ||= ""
    options[:tag] ||= :span
    options[:tag_content] ||= "<span>#{name}</span>"
    options[:target] ||= association.name.underscore.pluralize

    return content_tag(options[:tag],
      options[:tag_content].html_safe,
      :class => "cnf-add-entry #{options[:class]}",
      :style => options[:style],
      "data-association" => options[:pluralized],
      "data-js-template-name" => options[:js_template_name],
      "data-child-js-template-names" => options[:child_js_template_names],
      :id => "#{options[:js_template_name]}_button",
      "data-target" => options[:target])
  end

  ## remove_entry_button
  # arguments
  # - name: A string to be displayed as the button text
  # - target: a html tag ID that contains the element to be removed
  # - options: hash of override options
  #   - class: a string with any css class names to be used for styling
  #   - style: a string with any css styles
  #   - tag: override the returned tag
  #   - tag_content: override the returned tag content
  def remove_entry_button(name, association, options = {})
    options[:class] ||= ''
    options[:style] ||= ''
    options[:tag] ||= :div
    options[:tag_content] ||= "<span>#{name}</span>"
    options[:target] ||= ""

    return content_tag(
      options[:tag],
      options[:tag_content].html_safe,
      :style => options[:style],
      :class => "cnf-remove-entry #{options[:class]}",
      "data-target" => options[:target]
    )
  end

end
