$(document).ready(function() {
  var getBillingPeriod = function() {
    var period = null;
    var billingPeriods = $(".upgrade-billing-period-button");
    for (var i = 0; i < billingPeriods.length; i++) {
      if ($(billingPeriods[i]).hasClass("selected-billing-period-button")) {
        period = $(billingPeriods[i]).attr("data-billing-type");
      }
    }
    return period;
  }

  var getBillingAmount = function() {
    if (getBillingPeriod() == "monthly") {
      return 1000;
    } else {
      return 700 * 12;
    }
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

  var openStripeCheckout = function(key, email, url) {
    // var billingPeriod = getBillingPeriod();
    // var billingPeriodWord = null
    // if (billingPeriod == "monthly") {
    //   billingPeriodWord = "month";
    // } else {
    //   billingPeriodWord = "year";
    // }
    // var amount = getBillingAmount();
    var amount = 500;

    StripeCheckout.open({
      key:         key,
      address:     false,
      amount:      amount,
      name:        "Time Auction",
      description: "Get Supporter Status",
      email:       email,
      image:       "https://s3-us-west-2.amazonaws.com/timeauction/ta-icon.png",
      panelLabel:  "Pay {{amount}} per month",
      token: function(token, args) {
        $(".upgrade-account-modal-title").text("Thank you for upgrading");
        $(".remove-after-pay").toggle();
        $(".billing-bubble").remove();
        $(".upgrade-details-bold-text").text("Completing your upgrade - please wait...");
        $(".commit-clock-loader").toggle();

        $.ajax({
          url: url,
          data: {
            stripeToken: token
          }
        })
        .done(function(data) {
          window.location = data.url;
        })
      }
    })
  }

  $("#upgradeButton").click(function(){
    $.ajax({
      url: $("#upgradeButton").attr("data-url")
    })
    .done(function(data) {
      var key = data.key;
      var email = data.email;
      var url = data.url;
      openStripeCheckout(key, email, url);
    });
    return false;
  });

  if ($.cookie('first_time_sign_in') == "true") {
    // $('#upgrade-account-modal').foundation('reveal', 'open', '');
    $.cookie('first_time_sign_in', false)
  }

  $("body").on("click", ".no-thanks-on-premium", function() {
    $('#upgrade-account-modal').foundation('reveal', 'close', '');
  });

  $("body").on("click", ".upgrade-button", function() {
    $('#upgrade-payment-modal').foundation('reveal', 'open', {});
  });

  $("body").on("click", ".upgrade-billing-period-button", function() {
    formatSelectedBillingButton($(this));
  })

  checkIfUpgradePrompted();
});