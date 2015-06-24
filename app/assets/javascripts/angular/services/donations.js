var app = angular.module('timeauction');

app.factory("Donations", function(VolunteerHours, Bids) {
  var Donations = {};

  Donations.handler = function(scope) {
    var stripePublishableKey = $(".add-donations-form").attr("data-stripe-publishable-key")
    var handler = StripeCheckout.configure({
      key: stripePublishableKey,
      image: "https://s3-us-west-2.amazonaws.com/timeauction/ta-dark-logo.png",
      token: function(token) {
        // Use the token to create the charge with a server-side script.
        // You can access the token ID with `token.id`
        Donations.makeDonationCall(token, scope)
      }
    });
    return handler
  }

  Donations.openHandler = function(scope) {
    var email = $(".add-donations-form").attr("data-user-email")
    Donations.handler(scope).open({
      name: "Time Auction",
      description: "Donation to " + scope.charityName,
      amount: scope.donationAmount * 100,
      email: email,
      // bitcoin: true, // Can't support CAD yet...
      currency: "CAD"
    });
  }

  Donations.makeDonationCall = function(token, scope) {
    showLoader(scope)
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
        hideLoader(scope)
      } else {
        if (scope.bidPage) {
          if (scope.showVolunteerSection) {
            VolunteerHours.submitHours(scope)
          } else {
            Bids.callToCreate(scope)
          }
        } else {
          if (scope.showVolunteerSection) {
            $(".edit_user").submit();
          } else {
            window.location = Donations.afterDonationUrl()
          }
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

  function showLoader(scope) {
    if (scope.bidPage) {
      Bids.showCommitLoader()
    } else {
      $(".add-karma-main-button").attr("disabled", "disabled")
      $(".commit-clock-loader").show()
    }
  }

  function hideLoader(scope) {
    if (scope.bidPage) {
      Bids.hideCommitLoader()
    } else {
      $(".add-karma-main-button").removeAttr("disabled")
      $(".commit-clock-loader").hide()
    }
  }

  return Donations;
});