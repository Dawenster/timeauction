$(document).ready(function() {
  $("body").on("click", ".bid-button", function(e) {
    e.preventDefault();

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

    } else if ($(this).attr("data-enough-hours") == "false") {

      $(".log-hours-prompt-text").text("First, you will need to log some volunteer hours :) This auction has a minimum bid requirement of " + $(this).attr("data-min-bid") + " hours. You currently have " + $(this).attr("data-hours-to-bid") + " to bid.")
      $('#log-hours-modal').foundation('reveal', 'open', {});

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