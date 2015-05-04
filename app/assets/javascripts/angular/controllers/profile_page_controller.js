var app = angular.module('timeauction');

app.controller('ProfilePageCtrl', ['$scope', 'Users', function($scope, Users) {
  $scope.showAboutInput = false

  $scope.toggleAboutInput = function() {
    $(".about-me-input-holder").toggle()
  }

  $scope.saveAbout = function() {
    var url = $(".about-me-input-holder").attr("data-url")
    var text = $(".about-me-input").val()
    Users.saveAbout(url, text)
    updateAboutText(text)
  }

  function updateAboutText(text) {
    $scope.toggleAboutInput()
    if (text == "") {
      text = $(".about-me-input-holder").attr("data-empty-text")
    }
    $(".about-me-text").html(Users.makeIntoParagraphs(text))
  }
}]);