var app = angular.module('timeauction');

app.controller('AccountSettingsCtrl', ['$scope', function($scope) {
  $scope.showCancelAcount = false
  $scope.showCreditCardSection = false

  var stripePublishableKey = $(".update-card-holder").attr("data-stripe-publishable-key")
  var url = $(".update-card-holder").attr("data-donate-path")

  var handler = StripeCheckout.configure({
    key: stripePublishableKey,
    image: "https://s3-us-west-2.amazonaws.com/timeauction/ta-dark-logo.png",
    token: function(token) {
      // Use the token to create the charge with a server-side script.
      // You can access the token ID with `token.id`
      $.ajax({
        url: $(".update-card-holder").attr("data-url"),
        method: "post",
        data: {
          token: token,
          cardId: $scope.cardId
        }
      }).done(function(data) {
        location.reload(false)
      })
    }
  });

  $scope.updateCard = function($event) {
    var email = $(".update-card-holder").attr("data-user-email")
    $scope.cardId = $($event.target).parents(".card-buttons-holder").attr("data-card-id")
    handler.open({
      name: "Time Auction",
      description: "Update card information",
      email: email,
      panelLabel: "Update",
      // bitcoin: true, // Can't support CAD yet...
      currency: "CAD"
    });
  }
}]);