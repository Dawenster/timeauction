$(document).ready(function() {
  $("body").on("click", ".bid-button", function(e) {
    e.preventDefault();

    _gaq.push($(this).attr("data-ga").split("|"));

    var bidUrl = "/rewards/" + $(this).attr("data-reward-id");

    if ($(this).attr("data-signed-in") == "false") {

      $('#signup-modal').foundation('reveal', 'open', {});

    } else if ($(this).attr("data-auction-started") == "false") {

      $('#not-started-modal').foundation('reveal', 'open', {});

    } else if ($(this).attr("data-can-bid") == "false") {

      var whoCanBid = $(this).attr("data-who-can-bid");
      $(".select-organization-title").text("Only " + whoCanBid + " can bid on this auction. Please indicate which organizations you belong to below:")
      $('#select-organization-modal').foundation('reveal', 'open', {});

    } else if ($(this).attr("data-complete-org-info") == "false") {

      $(".select-organization-title").text("Please fill in all required fields before bidding:")
      $('#select-organization-modal').foundation('reveal', 'open', {});

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