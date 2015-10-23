var app = angular.module('timeauction');

app.controller('ProgramsFormCtrl', ['$scope', function($scope) {
  var auctionType = $(".program_auction_type option:selected").text()
  setShowDefaultContactDetails(auctionType)

  $("body").on("change", ".program_auction_type", function() {
    auctionType = $(".program_auction_type option:selected").text()
    setShowDefaultContactDetails(auctionType)
    $scope.$apply()
  })

  function setShowDefaultContactDetails(auctionType) {
    if (auctionType == "Must volunteer at org") {
      $scope.showDefaultContactDetails = true
    } else {
      $scope.showDefaultContactDetails = false
    }
  }
}]);