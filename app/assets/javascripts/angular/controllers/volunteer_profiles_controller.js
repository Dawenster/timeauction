var app = angular.module('timeauction.controllers', []);

app.controller('VolunteerProfilesCtrl', ['$scope', function($scope) {
  $("body").on("click", ".hours_entry-dates-holder-toggle", function() {
    $(this).siblings(".hours-entry-dates-holder").toggle()
  })
  
  $("body").on("click", ".hours-entry-date-toggle", function() {
    $(this).siblings(".hours-entry-details").toggle()
  })
}]);