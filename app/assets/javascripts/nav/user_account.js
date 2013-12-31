$(document).ready(function() {
  $("body").on("click", ".mobile-user-account-holder", function(e) {
    e.preventDefault();
    $("#mobile-user-account").toggle();
  });
});