var app = angular.module('timeauction');

app.factory("Nonprofits", [function() {
  var Nonprofits = {};

  Nonprofits.syncFields = function() {
    setInterval(function() { updateModel(); }, 500);
  }

  function updateModel() {
    $(".hidden-hours-entry-org-field").val($("#nonprofit_name").val())
  }

  return Nonprofits;
}]);