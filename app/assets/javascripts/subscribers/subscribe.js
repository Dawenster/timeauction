$(document).ready(function() {
  $("body").on("ajax:success", ".new_subscriber", function(e, data) {
    $(".subscriber-callback-message").html(data.message);
    $(this).siblings(".subscriber-alert-box-holder").removeClass("hide");
  });
});