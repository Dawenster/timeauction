var app = angular.module('timeauction');

app.controller('AddHoursCtrl', ['$scope', function($scope) {
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
    var minHours = $("#not-decided").data("min-hours")
    $(".hours").val(minHours)
    $(".user_hours_entries_contact_name input").val("TBD")
    $(".user_hours_entries_contact_position input").val("TBD")
    $(".user_hours_entries_contact_email input").val("tbd@tbd.com")
  }

  function clearFieldsForNotDecided() {
    $(".nonprofit-name-autocomplete").val("")
    $(".hours").val("")
    $(".user_hours_entries_contact_name input").val("")
    $(".user_hours_entries_contact_position input").val("")
    $(".user_hours_entries_contact_email input").val("")
  }
}]);