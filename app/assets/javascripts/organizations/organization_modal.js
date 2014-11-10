$(document).ready(function() {
  if ($.cookie('first_time_sign_in') == "true") {
    $('#select-organization-modal').foundation('reveal', 'open', '');
    $.cookie('first_time_sign_in', false)
  }
});