var app = angular.module('timeauction');

app.controller('OrgSpecificAddKarmaCtrl', ['$scope', 'Bids', 'Karmas', function($scope, Bids, Karmas) {
  $(".karma-count").stick_in_parent({parent: "body", bottoming: false})

  $scope.orgSpecificBid = true
  $scope.canGoToNextStep = false
  $scope.showVolunteerSection = true
  $(".new-hours-entry-holder").show() // So that users don't see the page in transition to hide certain sections
  $scope.totalKarmaToAdd = 0
  $scope.hoursExchangeRate = parseInt($(".add-hours-form").attr("data-hours-exchange-rate"))

  $scope.bidPage = $(".apply-step-holder").attr("data-bid-page") == "true"
  $scope.bids = Bids
  $scope.bids.karmaScope = $scope

  $("body").on("change", ".opportunity-select", function() {
    var selected = $(this).find("option:selected")
    var hiddenFieldsHolder = $(this).siblings(".hidden-fields-holder")
    hiddenFieldsHolder.find(".user_hours_entries_description input").val(selected.text())
    hiddenFieldsHolder.find(".user_hours_entries_amount input").val(selected.attr("data-hours"))
    hiddenFieldsHolder.find(".user_hours_entries_dates input").val(selected.attr("data-dates"))
    hiddenFieldsHolder.find(".user_hours_entries_contact_name input").val(selected.attr("data-contact-name"))
    hiddenFieldsHolder.find(".user_hours_entries_contact_position input").val(selected.attr("data-contact-position"))
    hiddenFieldsHolder.find(".user_hours_entries_contact_email input").val(selected.attr("data-contact-email"))
    hiddenFieldsHolder.find(".user_hours_entries_contact_phone input").val(selected.attr("data-contact-phone"))
    $scope.updateTotalKarma()
  })

  $("body").on('nested:fieldAdded', function(event){
    $scope.updateTotalKarma()
  })

  $("body").on('nested:fieldRemoved', function(event){
    $(event.target).remove()
    $scope.updateTotalKarma()
  });

  $scope.updateTotalKarma = function() {
    var sum = 0
    var selectedOpportunities = $(".opportunity-select option:selected")
    for (var i = 0; i < selectedOpportunities.length; i++) {
      var hours = parseInt($(selectedOpportunities[i]).attr("data-hours"))
      sum += hours * $scope.hoursExchangeRate
    };
    if (sum > 0) {
      $scope.canGoToNextStep = true
    } else {
      $scope.canGoToNextStep = false
    }
    $scope.pointsFromHoursOnly = sum
    $scope.totalKarmaToAdd = sum
    $(".total-karma-to-add").text(Karmas.commaSeparateNumber(sum))
  }
}]);















