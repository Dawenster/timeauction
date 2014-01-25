$(document).ready(function() {
  $("body").on("click", ".bid-button", function(e) {
    e.preventDefault();
    if ($(this).attr("data-signed-in") == "true") {
      $('#bid-modal').remove();
      $.ajax({
        url: "/rewards/" + $(this).attr("data-reward-id")
      })
      .done(function(data) {
        $(".main-section").after(data.result);
        $('#bid-modal').foundation('reveal', 'open', {});
      })
    } else {
      $('#signup-modal').foundation('reveal', 'open', {});
    }
  });

  $("body").on("click", ".second-reward-tab-link", function() {
    $("dd.active").removeClass("active");
    $(".reward-tab").addClass("active");
  });
});