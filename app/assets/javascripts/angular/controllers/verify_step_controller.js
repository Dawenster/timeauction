var app = angular.module('timeauction');

app.controller('VerifyStepCtrl', ['$scope', function($scope) {
  var minBid = parseInt($(".verify-step-holder").attr("data-min-bid"))
  var maxBid = Math.min(parseInt($(".hours-remaining-count").text()), parseInt($(".hours-remaining-count").attr("data-max-bid")))
  $scope.bidAmount = minBid
  greyOut($(".hours-toggles").find(".fa-toggle-down"))
  if (fixedBid()) {
    greyOut($(".hours-toggles").find(".fa-toggle-up"))
  }

  $scope.addHour = function() {
    if ($scope.bidAmount == minBid && !fixedBid()) {
      addColor($(".hours-toggles").find(".fa-toggle-down"))
    }

    if ($scope.bidAmount < maxBid) {
      $scope.bidAmount += 1
      if ($scope.bidAmount == maxBid) {
        greyOut($(".hours-toggles").find(".fa-toggle-up"))
      }
    }
  }

  $scope.minusHour = function() {
    if ($scope.bidAmount == maxBid && !fixedBid()) {
      addColor($(".hours-toggles").find(".fa-toggle-up"))
    }

    if ($scope.bidAmount > minBid) {
      $scope.bidAmount -= 1
      if ($scope.bidAmount == minBid) {
        greyOut($(".hours-toggles").find(".fa-toggle-down"))
      }
    }
  }

  function addColor(ele) {
    ele.attr("style", "color: #EB7F00; cursor: pointer;")
  }

  function greyOut(ele) {
    ele.attr("style", "color: grey; cursor: default;")
  }

  function fixedBid() {
    return minBid == maxBid
  }
}]);