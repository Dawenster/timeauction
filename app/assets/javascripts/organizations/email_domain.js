$(document).ready(function() {  
  $(".simple_form.edit_organization").on("click", ".remove_nested_fields", function(){
    $(this).siblings("input").val("true");
  });
});