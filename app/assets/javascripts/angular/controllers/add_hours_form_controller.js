var app = angular.module('timeauction');

app.controller('AddHoursFormCtrl', ['$scope', 'Karmas', function($scope, Karmas) {
  $("body").on("change", "#not-decided", function() {
    $(".not-decided").toggle()
    if ($(".not-decided:visible").length > 0) {
      clearFieldsForNotDecided()
    } else {
      fillInFieldsForNotDecided()
    }
  })

  function fillInFieldsForNotDecided() {
    $(".nonprofit-name-autocomplete").val("TBD")
    var hoursExchangeRate = parseInt($(".add-hours-form").attr("data-hours-exchange-rate"))
    if (!isKarmaPage()) {
      var minBid = parseInt($(".verify-step-holder").attr("data-min-bid").replace(",", ""))
      var hoursToBid = Math.ceil(minBid / hoursExchangeRate)
      $(".hours").val(hoursToBid)
      $(".total-karma-to-add").text(Karmas.commaSeparateNumber(hoursToBid * hoursExchangeRate))
    }
    $scope.bids.karmaScope.totalKarmaToAdd = hoursToBid * hoursExchangeRate
    $scope.bidAmount = $scope.bids.karmaScope.totalKarmaToAdd
    $(".user_hours_entries_contact_name input").val("TBD")
    $(".user_hours_entries_contact_position input").val("TBD")
    $(".user_hours_entries_contact_email input").val("tbd@tbd.com")
  }

  function clearFieldsForNotDecided() {
    $(".nonprofit-name-autocomplete").val("")
    $(".hours").val("")
    $(".total-karma-to-add").text("0")
    $scope.bids.karmaScope.totalKarmaToAdd = 0
    $(".user_hours_entries_contact_name input").val("")
    $(".user_hours_entries_contact_position input").val("")
    $(".user_hours_entries_contact_email input").val("")
  }

  function isKarmaPage() {
    return $(".add-hours-form").data("karma-page")
  }
}]);