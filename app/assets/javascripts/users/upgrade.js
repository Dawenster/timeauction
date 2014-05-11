$(document).ready(function() {
  var setupUpgrade = function() {
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
  }

  var getURLParameter = function(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
  }

  var removeParam = function(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
              param,
              params_arr = [],
              queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";

    if (queryString !== "") {
      params_arr = queryString.split("&");
      for (var i = params_arr.length - 1; i >= 0; i -= 1) {
        param = params_arr[i].split("=")[0];
        if (param === key) {
          params_arr.splice(i, 1);
        }
      }
      rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
  }

  var checkIfUpgradePrompted = function() {
    var currentURL = location.protocol + '//' + location.host + location.pathname;
    if ($(".user-avatar").is(":visible") && getURLParameter("upgrade") == "prompt") {
      $('#upgrade-account-modal').foundation('reveal', 'open', '');
      var pageTitle = $(document).find("title").text();
      var newURL = removeParam("upgrade", currentURL);
      history.pushState('', pageTitle, newURL);
    }
  }

  var formatSelectedBillingButton = function(button) {
    if (button.hasClass("not-selected-billing-period-button")) {
      button.removeClass("not-selected-billing-period-button");
      button.addClass("selected-billing-period-button");
      button.siblings(".upgrade-billing-period-button").removeClass("selected-billing-period-button");
      button.siblings(".upgrade-billing-period-button").addClass("not-selected-billing-period-button");
      $(".billing-bubble").toggle();
    }
  }

  if ($.cookie('first_time_sign_in') == "true") {
    $('#upgrade-account-modal').foundation('reveal', 'open', '');
    $.cookie('first_time_sign_in', false)
    setupUpgrade();
  }

  $("body").on("click", ".open-upgrade-modal", function() {
    setupUpgrade();
  })

  $("body").on("click", ".upgrade-billing-period-button", function() {
    formatSelectedBillingButton($(this));
  })

  checkIfUpgradePrompted();
});