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

  wistiaJQuery(document).ready( function() {
    var url = window.location.href.toString();
    if ( url.indexOf('launch-the-popover') != -1 )
    {
      wistiaJQuery('a[class^=wistia-popover]').last().click();
    }
  });
}]);