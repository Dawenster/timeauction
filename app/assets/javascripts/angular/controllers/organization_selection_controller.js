angular.module('timeauction', ['timeauction.controllers'])

var app = angular.module('timeauction.controllers', []);

app.controller('OrganizationSelectionCtrl', function($scope) {
  $.ajax({
    url: $("#select-organization-modal").attr("data-url"),
    async: false
  })
  .done(function(result) {
    $scope.organizations = result.organizations;
    for (var i = 0; i < $scope.organizations.length; i++) {
      if ($scope.organizations[i].already_member) {
        $scope.organizations[i].selected = true;
      }
    };
  });

  $scope.submitOrgs = function() {
    if (requiredInputsFilledIn()) {
      saveOrgDetailsToUser();
    }
  }

  var saveOrgDetailsToUser = function() {
    var inputs = $(".org-select-input:visible");
    var params = {organizations: {}};
    var orgs = {};

    for (var i = 0; i < inputs.length; i++) {
      var org = $(inputs[i]).attr("data-org-name");
      var name = $(inputs[i]).attr("name");
      var val = $(inputs[i]).val();

      if (!params["organizations"][org]) {
        params["organizations"][org] = [];
      }

      var pair = {};
      pair[name] = val;

      params["organizations"][org].push(pair);
    };

    $.ajax({
      url: $(".save-org-select-button").attr("data-url"),
      method: 'post',
      data: params
    })
    .done(function(result) {
      location.reload(false);
    });
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