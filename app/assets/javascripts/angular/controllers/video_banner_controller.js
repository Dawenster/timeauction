var app = angular.module('timeauction');

app.controller('VideoBannerCtrl', ['$scope', function($scope) {
  $scope.one = true

  $scope.toggleSection = function(section) {
    if (section == "one") {
      $(".video-banner-holder .section-one").show()
      $(".video-banner-holder .section-two").hide()
      $scope.one = true
    } else {
      $(".video-banner-holder .section-one").hide()
      $(".video-banner-holder .section-two").show()
      $scope.one = false
    }
  }
}]);