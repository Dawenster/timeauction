var app = angular.module('timeauction');

app.controller('HoursEntryCtrl', ['$scope', "Nonprofits", function($scope, Nonprofits) {
  Nonprofits.syncFields()
}]);