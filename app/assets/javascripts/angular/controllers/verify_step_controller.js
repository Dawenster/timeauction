var app = angular.module('timeauction.controllers', []);

app.controller('VerifyStepCtrl', ['$scope', 'Nonprofits', function($scope, Nonprofits) {
  Nonprofits.syncFields()
}]);