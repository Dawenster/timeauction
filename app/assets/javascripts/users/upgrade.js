$(document).ready(function() {
  $("body").on("click", ".open-upgrade-modal", function() {
    var key = null;
    var email = null;

    $.ajax({
      url: $("#upgradeButton").attr("data-url")
    })
    .done(function(data) {
      key = data.key;
      email = data.email;
      url = data.url;

      var handler = StripeCheckout.configure({
        key: key,
        image: "/assets/ta-icon.png",
        token: function(token, args) {
          $(".upgrade-account-modal-title").text("Thank you for upgrading");
          $(".remove-after-pay").remove();
          $(".upgrade-details-bold-text").text("Completing your upgrade - please wait...");
          $(".commit-clock-loader").toggle();

          $.ajax({
            url: url,
            data: { stripeToken: token }
          })
          .done(function(data) {
            window.location = data.url;
          })
        }
      });

      document.getElementById("upgradeButton").addEventListener("click", function(e) {
        // Open Checkout with further options
        handler.open({
          name: "Time Auction Upgrade",
          description: "Get Supporter Status",
          amount: 500,
          email: email,
          panelLabel: "Pay {{amount}} per month"
        });
        e.preventDefault();
      });
    })
  })
});