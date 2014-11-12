angular.module('timeauction', ['timeauction.controllers'])

var app = angular.module('timeauction.controllers', []);

app.controller('OrganizationSelectionCtrl', function($scope) {
  $.ajax({
    url: $("#select-organization-modal").attr("data-url"),
    async: false
  })
  .done(function(result) {
    $scope.organizations = result.organizations;
  });

  $scope.submitOrgs = function() {
    requiredInputsFilledIn();
  }

  var requiredInputsFilledIn = function() {
    hideErrors();
    var errorCount = 0;
    var inputs = $(".requiredOrgSelectInput:visible");
    var firstErrorPosition = 0;
    
    for (var i = 0; i < inputs.length; i++) {
      var value = $(inputs[i]).val().trim();
      if (value == "") {
        $(inputs[i]).siblings(".error").toggle();
        errorCount += 1;
        if (errorCount == 1) {
          firstErrorPosition = $(inputs[i]).offset().top - 30;
        }
      }
    };

    if (errorCount == 0) {
      return true;
    } else {
      $('html,body').scrollTop(firstErrorPosition);
      return false;
    }
  }

  var hideErrors = function() {
    var errors = $(".error:visible");

    for (var i = 0; i < errors.length; i++) {
      $(errors[i]).toggle();
    };
  }
});