$(document).ready(function() {
  $("body").on("click", ".bid-button", function(e) {
    e.preventDefault();
    var bidUrl = "/rewards/" + $(this).attr("data-reward-id");

    if ($(this).attr("data-signed-in") == "false") {

      $('#signup-modal').foundation('reveal', 'open', {});

    } else if ($(this).attr("data-auction-started") == "false") {

      $('.subscribe-box-holder').remove();
      $.ajax({
        url: $(this).attr("data-auction-not-started-path") + "?id=" + $(this).attr("data-reward-id")
      })
      .done(function(data) {
        $(".main-section").after(data.result);
        $('#not-started-modal').foundation('reveal', 'open', {});
      })

    } else if ($(this).attr("data-premium") == "true") {

      var result = null;

      $.ajax({
        url: $(this).attr("data-check-user-premium-path")
      })
      .done(function(data) {
        result = data.result;
        if (result == false) {
          $('#upgrade-account-modal').foundation('reveal', 'open', {});
        } else {
          $.ajax({
            url: bidUrl
          })
          .done(function(data) {
            $(".main-section").after(data.result);
            $('#bid-modal').foundation('reveal', 'open', {});
          })
        }
      })
    } else {
      $.ajax({
        url: bidUrl
      })
      .done(function(data) {
        $(".main-section").after(data.result);
        $('#bid-modal').foundation('reveal', 'open', {});
      })
    }
  });

  // $("body").on("click", ".second-reward-tab-link", function() {
  //   $("dd.active").removeClass("active");
  //   $(".reward-tab").addClass("active");
  // });

  var showAfterBidModal = function() {
    if ($.cookie('just-bid') == "true") {
      $('#after-bid-modal').foundation('reveal', 'open', {});
      $.cookie('just-bid', false);
    }
  }
  window.onload = showAfterBidModal;
});