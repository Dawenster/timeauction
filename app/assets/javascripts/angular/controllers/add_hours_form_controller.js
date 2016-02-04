var app = angular.module('timeauction');

app.controller('AddHoursFormCtrl', ['$scope', 'Karmas', function($scope, Karmas) {
  $("body").on("change", "#not-decided", function(event) {
    var parent = $(event.target).parents(".individual-hours-entry-fields")
    parent.find(".not-decided").toggle()
    if (parent.find(".not-decided:visible").length > 0) {
      clearFieldsForNotDecided(parent)
    } else {
      fillInFieldsForNotDecided(parent)
    }
  })

  function fillInFieldsForNotDecided(parent) {
    parent.find(".nonprofit-name-autocomplete").val("TBD")
    // parent.find(".user_hours_entries_contact_name input").val("TBD")
    // parent.find(".user_hours_entries_contact_position input").val("TBD")
    // parent.find(".user_hours_entries_contact_email input").val("tbd@tbd.com")
  }

  function clearFieldsForNotDecided(parent) {
    parent.find(".nonprofit-name-autocomplete").val("")
    // parent.find(".hours").val("")
    // $(".total-karma-to-add").text("-")
    // $scope.bids.karmaScope.totalKarmaToAdd = 0
    // parent.find(".user_hours_entries_contact_name input").val("")
    // parent.find(".user_hours_entries_contact_position input").val("")
    // parent.find(".user_hours_entries_contact_email input").val("")
  }
}]);