$(document).ready(function() {
  if ($.cookie('first_time_sign_in') == "true") {
    $('#select-organization-modal').foundation('reveal', 'open', '');
    $.cookie('first_time_sign_in', false)
  }
  $(".org-select-dropdown").change(function(e) {
    var selectedText = this.options[e.target.selectedIndex].text;
    if (selectedText == "Other") {
      $(this).siblings("input.other-field").toggle();
    } else if ($("input.other-field").is(":visible")) {
      $(this).siblings("input.other-field").toggle();
    }
  })
});