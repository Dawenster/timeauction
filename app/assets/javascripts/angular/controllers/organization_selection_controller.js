var app = angular.module('timeauction.controllers', []);

app.controller('OrganizationSelectionCtrl', ['$scope', function($scope) {
  if ($("#select-organization-modal").attr("data-fetch-orgs") == "true") {
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
  };

  $scope.dropdownValue = function(field, field_value) {
    if (!field_value) {
      return field.select_options[0];
    } else if (field.select_options.indexOf(field_value) != -1) {
      field.showOther = false;
      return field_value;
    } else {
      field.showOther = true;
      return "Other";
    }
  }

  $scope.dropdownChange = function(field, selected_option) {
    if (selected_option == "Other") {
      field.showOther = true;
    } else {
      field.showOther = false;
    }
  }

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
      var val = $(inputs[i]).find(":selected").text() || $(inputs[i]).val() || $(inputs[i]).is(":checked");

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
      var url = result.redirect_url;
      if ($(".auction-show-holder").length > 0 || !url) {
        location.reload(false);
        $('html,body').scrollTop(0);
      } else {
        window.location = "/" + url
      }
    });
  }

  var requiredInputsFilledIn = function() {
    hideErrors();
    var errorCount = 0;
    var inputs = $(".requiredOrgSelectInput:visible");
    var firstErrorPosition = 0;
    
    for (var i = 0; i < inputs.length; i++) {
      var value = $(inputs[i]).val().trim();
      if ($(inputs[i]).is(":checkbox")) {
        if (!$(inputs[i]).is(":checked")) {
          $(inputs[i]).siblings(".error").toggle();
          errorCount += 1;
          if (errorCount == 1) {
            firstErrorPosition = $(inputs[i]).offset().top - 30;
          }
        }
      } else {
        if (value == "") {
          $(inputs[i]).siblings(".error").toggle();
          errorCount += 1;
          if (errorCount == 1) {
            firstErrorPosition = $(inputs[i]).offset().top - 30;
          }
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
}]);