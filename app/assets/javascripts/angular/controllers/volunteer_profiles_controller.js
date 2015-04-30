var app = angular.module('timeauction.controllers', []);

app.controller('VolunteerProfilesCtrl', ['$scope', function($scope) {
  $("body").on("click", ".hours_entry-dates-holder-toggle", function() {
    toggleDateToggles()
    toggleDatesHolder($(this))
  })

  $("body").on("click", ".hours-entry-date-toggle", function() {
    $(this).siblings(".hours-entry-details").toggle()
  })

  function toggleDateToggles() {
    $(".plus-toggle").toggle()
    $(".minus-toggle").toggle()
  }

  function toggleDatesHolder(ele) {
    ele.siblings(".hours-entry-dates-holder").toggle()
  }
}]);