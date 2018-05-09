$(function(){
  $(document).on('click', '.cnf-add-entry', function() {
    // initialize options
    var association = $(this).attr('data-association');
    var jsTemplateName = $(this).attr('data-js-template-name');
    var childTemplates = $(this).attr('data-child-js-template-names').split(' ');
    var target = $(this).attr('data-target');

    // initialize regular expressions
    var associationNewRegEx = new RegExp('new_' + association, 'g');
    var tempIdRegEx = new RegExp('\\[tempid\\]', 'g');
    var childTempIdRegEx = new RegExp('_tempid_', 'g');

    // create a temporary id
    var newId = new Date().getTime();

    // select where to append the new element
    var container = (target == '') ? $(this).parent() : $('#'+target);

    // append the new emelent andreplace all temp_ids
    container.append(window[ jsTemplateName ].replace(associationNewRegEx, newId).replace(tempIdRegEx, newId));

    // parse any child templates
    for(var index in childTemplates) {

      childTemplate = childTemplates[index];

      if(childTemplate != ""){
        // get the template
        body = window[childTemplate];
        // generate the script tag
        child_script_tag = "<script> var " + childTemplate + " = '" + body + "'  </script>";
        // substitute all the temp ids
        child_script_tag = child_script_tag.replace(childTempIdRegEx, "_" + newId + "_")
                            .replace(associationNewRegEx, newId);
        // append the child script tag to the target container
        // this generates a new script tag associated to the element created
        // before this loop
        container.append(child_script_tag.replace(childTempIdRegEx, "_" + newId + "_"));
      }
    }
    // trigger event coolNestedForms.entryAdded
    $(document).trigger('coolNestedForms.entryAdded');
    // false to avoid errors
    return false;
  });
  $(document).on('click', '.cnf-remove-entry', function() {
    // get the target attribute. this is the target entry container.
    var target = $(this).attr('data-target');
    // initialize the container
    var container = "";
    // target provided?
    if(target == ""){
      // default to the parent container
      container = $(this).parent();
    }
    else {
      // use the target provided
      container = $('#' + target);
    }
    // update the hidden field that sets the record for removal
    container.find('.cnf-removable')[0].value = 1;
    // hide the container for user feedback
    container.hide();
    // trigger event coolNestedForms.entryRemoved
    $(document).trigger('coolNestedForms.entryRemoved');
    // false to avoid errors
    return false;
  });

});
