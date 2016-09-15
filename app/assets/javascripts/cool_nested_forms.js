$(function(){
  $(document).delegate('.add_child','click', function() {
    var association = $(this).attr('data-association');
    var template = $(this).attr('data-association-template');
    var child_templates = $(this).attr('data-child-template').split(' ');
    var target = $(this).attr('target');
    var regexp = new RegExp('new_' + association, 'g');
    var regexp2 = new RegExp('\\[tempid\\]', 'g');
    var regexp_child_template = new RegExp('_tempid_', 'g');
    var regexp_parent_new_field = new RegExp('new_' + association, 'g');
    var new_id = new Date().getTime();
    var Dest = (target == '') ? $(this).parent() : $('#'+target);
    Dest.append(window[ template +'_fields'].replace(regexp, new_id).replace(regexp2, new_id));
    for(var index in child_templates)
    {
      child_template = child_templates[index];
      if(child_template != "")
      {
        body = window[child_template];
        child_script_tag = "<script> var " + child_template + " = '" + body + "'  </script>";
        child_script_tag = child_script_tag.replace(regexp_child_template, "_" + new_id + "_")
                            .replace(regexp_parent_new_field, new_id);
        Dest.append(child_script_tag.replace(regexp_child_template, "_" + new_id + "_"));
      }
    }
    $(document).trigger('coolNestedForms.childAdded');
    return false;
  });

  $(document).delegate('.remove_child','click', function() {
    $(this).parent().children('.removable')[0].value = 1;
    $(this).parent().hide();
    $(document).trigger('coolNestedForms.childRemoved');
    return false;
  });
});
