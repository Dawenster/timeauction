$(document).ready(function() {
  $("body").on("click", ".bid-button", function(e) {
    e.preventDefault();

    _gaq.push($(this).attr("data-ga").split("|"));

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

    } else if ($(this).attr("data-can-bid") == "false") {

      var whoCanBid = $(this).attr("data-who-can-bid");
      $(".select-organization-title").text("Only " + whoCanBid + " can bid on this reward. Please indicate which organizations you belong to below:")
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