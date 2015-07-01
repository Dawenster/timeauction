var app = angular.module('timeauction');

app.controller('ProfilePageCtrl', ['$scope', 'Users', function($scope, Users) {
  $scope.showAboutInput = false
  $scope.volunteerSection = true
  $(".tabs-sections-holder").show()

  $scope.toggleAboutInput = function() {
    $(".about-me-input-holder").toggle()
  }

  $scope.toggleHoursCount = function() {
    $(".hours-count-details-holder").toggle()
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

  $scope.tabSelection = function(event) {
    var section = $(event.target).attr("data-section") || $(event.target).parents(".section-tab").attr("data-section")
    if (section == "volunteering") {
      allSectionsFalse()
      $scope.volunteerSection = true
    } else if (section == "donations") {
      allSectionsFalse()
      $scope.donationSection = true
    } else if (section == "bids") {
      allSectionsFalse()
      $scope.bidsSection = true
    } else { // Activity section
      allSectionsFalse()
      $scope.activitySection = true
    }
  }

  function allSectionsFalse() {
    $scope.volunteerSection = false
    $scope.donationSection = false
    $scope.bidsSection = false
    $scope.activitySection = false
  }
}]);