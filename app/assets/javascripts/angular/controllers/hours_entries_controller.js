var app = angular.module('timeauction');

app.controller('HoursEntryCtrl', ['$scope', function($scope) {
  setInterval(function() { updateModel(); }, 500);

  function updateModel() {
    $("#hours_entry_organization").val($("#nonprofit_name").val())
  }
}]);