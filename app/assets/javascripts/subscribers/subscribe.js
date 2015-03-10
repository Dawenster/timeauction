$(document).ready(function() {
  $("body").on("ajax:success", ".new_subscriber", function(e, data) {
    location.reload(false)
    $('html,body').scrollTop(0);
    // $(".subscriber-callback-message").html(data.message);
    // $(this).siblings(".subscriber-alert-box-holder").removeClass("hide");
  });
});