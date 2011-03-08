jQuery(function($) {
  function fire(obj, name, data) {
    var event = new $.Event(name);
    obj.trigger(event, data);
    return event.result !== false;
  }

  $("form a.add_nested_fields").live("click", function() {
    var association = $(this).attr("data-association");
    var content     = $("#" + association + "_fields_blueprint").html();

    var context = ($(this).closest(".fields").find("input:first").attr("name") || "").replace(new RegExp("\[[a-z]+\]$"), "");

    if (context) {
      var parentNames = context.match(/[a-z_]+_attributes/g) || [];
      var parentIds   = context.match(/[0-9]+/g);

      for(i = 0; i < parentNames.length; i++) {
        if(parentIds[i]) {
          content = content.replace(
            new RegExp("(\\[" + parentNames[i] + "\\])\\[.+?\\]", "g"),
            "$1[" + parentIds[i] + "]"
          )
        }
      }
    }

    content = content.replace(new RegExp("new_" + association, "g"), new Date().getTime());

    if(fire($(this), 'nestedFields:beforeAdd', [content, association])) {
      $(this).before(content);
      $(this).trigger('nestedFields:afterAdd', [$(this).prev(), association]);
    }

    return false;
  });

  $("form a.remove_nested_fields").live("click", function() {
    var destroyField = $(this).prev("input[type=hidden]")[0];

    if(fire($(this), "nestedFields:beforeRemove", [element])) {
      if (destroyField) {
        destroyField.value = "1";
      }
      element.hide();
    }

    return false;
  });
});
