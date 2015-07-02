var app = angular.module('timeauction');

app.controller('DonationsProfileCtrl', ['$scope', function($scope) {
  $scope.showDonationDetails = function(event) {
    var ele = null
    if ($(event.target).hasClass("show-details-button")) {
      ele = $(event.target).siblings(".donation-details")
      $(event.target).find(".show-details-text").toggle()
      $(event.target).find(".hide-details-text").toggle()
    } else {
      ele = $(event.target).parents(".show-details-button").siblings(".donation-details")
      $(event.target).toggle()
      $(event.target).siblings(".other-detail-type").toggle()
    } 
    ele.toggle()
  }
}]);