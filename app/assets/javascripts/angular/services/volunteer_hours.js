var app = angular.module('timeauction.services', []);

app.factory("VolunteerHours", ['Bids', function(Bids) {
  var VolunteerHours = {};

  VolunteerHours.fieldsValidation = function(errors) {
    var individualEntryFields = $(".individual-hours-entry-fields:visible")

    $(".js-added-error").remove()

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
      } else if (!Bids.isEmail(contactEmail.val().trim())) {
        errors.push({
          ele: contactEmail,
          message: "not an email"
        })
      }
    };
    return errors
  }

  VolunteerHours.hoursValidation = function(errors) {
    var hoursEntries = $(".hours-month-year-entry:visible")

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

  VolunteerHours.displayErrors = function(errors) {
    for (var i = 0; i < errors.length; i++) {
      var errorDiv = errors[i].ele.siblings(".error")
      if (errorDiv.length == 0) {
        errors[i].ele.parents(".holder-for-error-box").find(".error").append("<small class='js-added-error'>" + errors[i].message + "</small>")
      } else {
        errorDiv.append("<small class='js-added-error'>" + errors[i].message + "</small>")
      }
    };

    $(".total-karma-to-add").text("-")

    $('html, body').animate({
      scrollTop: errors[0].ele.offset().top - 30 + 'px'
    }, 'fast');
  }

  VolunteerHours.submitHours = function(scope) {
    var hoursForm = $(".edit_user").serializeArray();
    $.ajax({
      url: $(".edit_user").attr("action"),
      method: "patch",
      data: hoursForm
    })
    .done(function(data) {
      if (data.fail) {
        $.cookie('just-bid', false, { path: '/' });
        location.reload(false)
      } else {
        $.cookie('just-bid', true, { path: '/' });
        Bids.callToCreate(scope)
      }
    })
  }

  return VolunteerHours;
}]);