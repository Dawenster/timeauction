var app = angular.module('timeauction');

app.factory("Donations", function() {
  var Donations = {};

  Donations.makeDonationCall = function(url, token, scope, afterDonationOnlyUrl) {
    $.ajax({
      url: url,
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
          window.location = afterDonationOnlyUrl
        }
      }
    })
  }

  return Donations;
});