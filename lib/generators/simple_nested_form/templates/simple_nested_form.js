jQuery(function($) {
  function fire(obj, name, data) {
    var event = new $.Event(name);
    obj.trigger(event, data);
    return event.result !== false;
  }

  $("form").delegate("a[data-association]", "click", function() {
    var association = $(this).data("association");
    var content     = $("#" + association + "_fields_blueprint").html();
    var limit       = $(this).data("limit");

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

    if(fire($(this), "fields:beforeadd", [content, association])) {
      if(!limit || $(this).prevAll(".fields:visible").length < parseInt(limit)) {
        $(this).before(content);
        $(this).trigger("fields:afteradd", [$(this).prev(), association]);
      }
    }

    return false;
  });

  $("form").delegate("a[data-remove-association]", "click", function() {
    var destroyField = $(this).prev("input[type=hidden]")[0];
    var element = $(this).closest(".fields");

    if(fire($(this), "fields:beforeremove", [element])) {
      if (destroyField) {
        destroyField.value = "1";
      }

      var waitForPossibleAnimations = setInterval(function() {
        if(!element.is(":animated")) {
          clearInterval(waitForPossibleAnimations);
          element.hide();
        }
      }, 100);
    }

    return false;
  });
});
