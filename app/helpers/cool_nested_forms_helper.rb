module CoolNestedFormsHelper

  ## new_entry_template ##
  # arguments
  # - builder: a FormBuilder Object obtained from form_with or form_for
  # - association: a model class i.e. MyTask
  # - options: hash of override options
  #   - partial: name of the erb partial to use as a tempalte
  #   - plurilized: the plural version of the model name
  #   - js_template_name: name for the javascript variable generated by this method ( useful when there are multiple nested associations)
  #   - children: an array with childre association options for nested association of a nested association
  def new_entry_template(builder,association, options = {})
    # initialize options
    options[:partial] ||= association.name.snakecase
    options[:pluralized] ||= association.name.snakecase.pluralize
    options[:js_template_name] ||= association.name.snakecase.pluralize
    options[:children] ||= []

    # render the template using the form builder object and the association
    output = builder.fields_for(options[:pluralized],association.new, :child_index => "new_#{options[:pluralized]}") do |b|
      render(:partial=>options[:partial],:locals =>{:f => b})
    end

    # remove any new line characters
    output = output.gsub( /\r?\n|\r/, ' ')

    # create the script tag that will be output to the page
    script_tag = "<script> var #{options[:js_template_name]} = '#{output}'; </script>"

    # retunr the output as html safe
    return script_tag.html_safe
  end

  def new_entry_button(name, association, target, options = {})
    options[:pluralized] ||= association.name.snakecase.pluralize
    options[:js_template_name] ||= association.name.snakecase.pluralize
    options[:class] ||= ""
    options[:child_js_template_names] ||= ""
    options[:tag] ||= :span
    options[:tag_content] ||= "<span>#{name}</span>"

    content_tag(options[:tag],
      options[:tag_content].html_safe,
      :class => "cnf-add-entry #{options[:class]}",
      :style => "",
      "data-association" => options[:pluralized],
      "data-js-template-name" => options[:js_template_name],
      "data-child-js-template-names" => options[:child_js_template_names],
      :id => "#{options[:js_template_name]}_button",
      "data-target" => target)
  end


  def new_fields_template(f,association,options={})
    options[:object] ||= f.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:template] ||= association.to_s
    options[:child_template_options] ||= []
    options[:f] ||= f

    child_tmpl = ""
    tmpl = content_tag(:div,:id =>"#{options[:template]}") do
      tmpl = f.fields_for(association,options[:object], :child_index => "new_#{association}") do |b|
        if options[:child_template_options].count > 0
          options[:child_template_options].each do |child|
            child_tmpl += new_fields_template(b,child[:association],child)
          end
          child_tmpl = child_tmpl.gsub( /\r?\n|\r/, ' ')
        end
        render(:partial=>options[:partial],:locals =>{:f => b})
      end
    end

    tmpl = tmpl.gsub( /\r?\n|\r/, ' ')
    script = "<script> var #{options[:template]} = '#{tmpl.to_s}'; </script>"
    script += child_tmpl
    return script.html_safe
  end

  def add_child_button(name, association,target,association_template="",classes="",child_template="")
    association_template = association if association_template.blank?
    content_tag(:span,"<span>#{name}</span>".html_safe,
      :class => "add_child #{classes}",
      :style => "",
      :"data-association" => association,
      :"data-association-template" => association_template,
      :"data-child-template" => child_template,
      :id => "#{association_template}_button",
      :target => target)
  end
  def remove_child_button(name, classes="", inner_html="<span>Remove</span>")
    content_tag(:div,inner_html.html_safe,
      :style => "",
      :class => "remove_child #{classes}")
  end
end
