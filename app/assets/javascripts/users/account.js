$(document).ready(function() {
  $("body").on("click", ".change-password-link", function() {
    if ($(this).text() == "Change password") {
      $(this).text("Hide password change");
    } else {
      $(this).text("Change password");
    }
    $(".change-password").toggle();
  });
});