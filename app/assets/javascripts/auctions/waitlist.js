$(document).ready(function() {
  $(document).on("click", ".waitlist-button", function() {
    $(".waitlist-clicked").click();
  });

  $(document).on('closed', '#waitlist-modal', function () {
    $(".waitlist-clicked").removeClass("waitlist-clicked");
  });
});