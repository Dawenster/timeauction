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
});