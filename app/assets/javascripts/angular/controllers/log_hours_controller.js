var app = angular.module('timeauction');

app.controller('LogHoursCtrl', ['$scope', function($scope) {
  replaceDefaultText()

  function replaceDefaultText() {
    var forms = $(".edit_hours_entry")
    for (var i = 0; i < forms.length; i++) {
      var descriptionElement = $(forms[i]).find("#hours_entry_description")
      var contactNameElement = $(forms[i]).find("#hours_entry_contact_name")
      var contactEmailElement = $(forms[i]).find("#hours_entry_contact_email")
      var contactPositionElement = $(forms[i]).find("#hours_entry_contact_position")

      if (descriptionElement.val() == "N/A") {
        descriptionElement.val("")
      }
      if (contactNameElement.val() == "TBD") {
        contactNameElement.val("")
      }
      if (contactEmailElement.val() == "tbd@tbd.com") {
        contactEmailElement.val("")
      }
      if (contactPositionElement.val() == "TBD") {
        contactPositionElement.val("")
      }
    };
  }
}]);