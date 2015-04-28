var app = angular.module('timeauction');

app.factory("Nonprofits", function() {
  var Nonprofits = {};

  Nonprofits.syncFields = function() {
    setInterval(function() { updateModel(); }, 500);
  }

  function updateModel() {
    $("#hours_entry_organization").val($("#nonprofit_name").val())
  }
  
  return Nonprofits;
});