$(document).ready(function() {
  $("body").on("click", ".signup-by-email-link", function(e) {
    e.preventDefault();
    $(".signup-by-email").toggle();
  });
});