var app = angular.module('timeauction.controllers', []);

app.controller('WhatCountsCtrl', ['$scope', function($scope) {
  $scope.closeModal = function() {
    $('#what-counts-as-hours-modal').foundation('reveal', 'close', '');
  }
}]);