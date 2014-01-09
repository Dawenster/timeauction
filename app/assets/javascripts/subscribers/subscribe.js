$(document).ready(function() {
  $(".new_subscriber").on("ajax:success", function(e, data) {
    $(".subscriber-callback-message").html(data.message);
    $(this).siblings(".subscriber-alert-box-holder").removeClass("hide");
  });
});