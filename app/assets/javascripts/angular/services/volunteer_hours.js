var app = angular.module('timeauction.services', []);

app.factory("VolunteerHours", function() {
  var VolunteerHours = {};

  VolunteerHours.fieldsValidation = function(individualEntryFields, errors) {
    for (var i = 0; i < individualEntryFields.length; i++) {
      var org = $(individualEntryFields[i]).find(".nonprofit-name-autocomplete")
      if (org.val().trim() == "") {
        errors.push({
          ele: org,
          message: "please fill in"
        })
      }

      var description = $(individualEntryFields[i]).find(".user_hours_entries_description").find("textarea")
      if (description.val().trim() == "") {
        errors.push({
          ele: description,
          message: "please fill in"
        })
      }

      var contactName = $(individualEntryFields[i]).find(".user_hours_entries_contact_name").find("input")
      if (contactName.val().trim() == "") {
        errors.push({
          ele: contactName,
          message: "please fill in"
        })
      }

      var contactPosition = $(individualEntryFields[i]).find(".user_hours_entries_contact_position").find("input")
      if (contactPosition.val().trim() == "") {
        errors.push({
          ele: contactPosition,
          message: "please fill in"
        })
      }

      var contactPhone = $(individualEntryFields[i]).find(".user_hours_entries_contact_phone").find("input")
      if (contactPhone.val().trim() == "") {
        errors.push({
          ele: contactPhone,
          message: "please fill in"
        })
      }

      var contactEmail = $(individualEntryFields[i]).find(".user_hours_entries_contact_email").find("input")
      if (contactEmail.val().trim() == "") {
        errors.push({
          ele: contactEmail,
          message: "please fill in"
        })
      } else if (!isEmail(contactEmail.val().trim())) {
        errors.push({
          ele: contactEmail,
          message: "not an email"
        })
      }
    };
    return errors
  }

  var isEmail = function(email) {      
    var emailReg = /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i;
    return emailReg.test(email);
  }

  VolunteerHours.hoursValidation = function(hoursEntries, errors) {
    for (var i = 0; i < hoursEntries.length; i++) {
      var hoursElement = $(hoursEntries[i]).find(".hours")
      var hours = hoursElement.val().trim()
      if (isNaN(hours) || hours == "") {
        errors.push({
          ele: hoursElement,
          message: "please fill in"
        })
      } else if (parseInt(hours) <= 0) {
        errors.push({
          ele: hoursElement,
          message: "be positive"
        })
      } else if (hours % 1 != 0) {
        errors.push({
          ele: hoursElement,
          message: "no decimals"
        })
      } else if (hours > 744) { // The number of hours in a 31-day month
        errors.push({
          ele: hoursElement,
          message: "check again..."
        })
      }
    };
    return errors
  }

  return VolunteerHours;
});