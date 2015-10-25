$(document).ready(function() {
  $("body").on("click", ".bid-button", function(e) {
    e.preventDefault();

    var bidUrl = "/rewards/" + $(this).attr("data-reward-id");

    if ($(this).attr("data-auction-started") == "false") {

      $('#not-started-modal').foundation('reveal', 'open', {});
      
    } else if ($(this).attr("data-at-max-bid") == "true") {

      $('#at-max-bid-modal').foundation('reveal', 'open', {});

    } else {

      window.location = $(this).attr("data-bid-path");
      
    }
  });

  var showAfterBidModal = function() {
    if ($.cookie('just-bid') == "true") {
      $('#after-bid-modal').foundation('reveal', 'open', {});
      $.cookie('just-bid', false, { path: '/' });
    }
  }
  window.onload = showAfterBidModal;
});