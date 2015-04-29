var app = angular.module('timeauction');

app.controller('VerifyStepCtrl', ['$scope', 'Nonprofits', function($scope, Nonprofits) {
  Nonprofits.syncFields()
}]);