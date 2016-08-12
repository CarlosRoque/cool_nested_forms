module CoolNestedFormsHelper

    def new_fields_template(f,association,options={})
      options[:object] ||= f.object.class.reflect_on_association(association).klass.new
      options[:partial] ||= association.to_s.singularize+"_fields"
      options[:template] ||= association.to_s+"_fields"
      options[:child_template_options] ||= []
      options[:f] ||= f

      child_tmpl = ""
      tmpl = content_tag(:div,:id =>"#{options[:template]}") do
        tmpl = f.fields_for(association,options[:object], :child_index => "new_#{association}") do |b|
          if options[:child_template_options].count > 0
            options[:child_template_options].each do |child|
              child_tmpl += new_fields_template(b,child[:association],child)
            end
            child_tmpl = child_tmpl.gsub /\r?\n|\r/, ' '
          end
          render(:partial=>options[:partial],:locals =>{:f => b})
        end
      end

      tmpl = tmpl.gsub /\r?\n|\r/, ' '
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
