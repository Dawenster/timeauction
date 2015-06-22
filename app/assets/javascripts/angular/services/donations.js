var app = angular.module('timeauction');

app.factory("Donations", function() {
  var Donations = {};

  Donations.handler = function(scope) {
    var stripePublishableKey = $(".add-donations-form").attr("data-stripe-publishable-key")
    var handler = StripeCheckout.configure({
      key: stripePublishableKey,
      image: "https://s3-us-west-2.amazonaws.com/timeauction/ta-dark-logo.png",
      token: function(token) {
        // Use the token to create the charge with a server-side script.
        // You can access the token ID with `token.id`
        showLoader()
        Donations.makeDonationCall(token, scope)
      }
    });
    return handler
  }

  Donations.makeDonationCall = function(token, scope) {
    showLoader()
    $.ajax({
      url: Donations.makeDonationUrl(),
      method: "post",
      data: {
        token: token,
        amount: scope.donationAmount * 100,
        charity_id: scope.charityId,
        charity_name: scope.charityName,
        tip: $(".ta-tip-range-slider").val() * 100
      }
    }).done(function(data) {
      if (data.status == "error") {
        $(".custom-input-error").text(data.result.message)
        hideLoader()
      } else {
        if (scope.showVolunteerSection) {
          $(".edit_user").submit();
        } else {
          window.location = Donations.afterDonationUrl()
        }
      }
    })
  }

  Donations.makeDonationUrl = function() {
    return $(".add-donations-form").attr("data-donate-path")
  }

  Donations.afterDonationUrl = function() {
    return $(".add-donations-form").attr("data-after-donation-only-path")
  }

  function showLoader() {
    $(".add-karma-main-button").attr("disabled", "disabled")
    $(".commit-clock-loader").show()
  }

  function hideLoader() {
    $(".add-karma-main-button").removeAttr("disabled")
    $(".commit-clock-loader").hide()
  }

  return Donations;
});