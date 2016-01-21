var app = angular.module('timeauction');

app.controller('AddHoursCtrl', ['$scope', function($scope) {
  $("body").on("change", "#not-decided", function() {
    $(".not-decided").toggle()
  })
}]);