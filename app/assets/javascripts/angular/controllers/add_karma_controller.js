var app = angular.module('timeauction');

app.controller('AddKarmaCtrl', ['$scope', "Nonprofits", function($scope, Nonprofits) {
  // Nonprofits.syncFields()
  syncHoursFields()

  $(".karma-count").stick_in_parent({parent: "body", bottoming: false})

  $scope.showDonateSection = false
  $scope.showVolunteerSection = false
  $(".new-hours-entry-holder").show() // So that users don't see the page in transition to hide certain sections
  $scope.canSelectAll = true
  $scope.lastMonth = new Date($(".month-selection").last().attr("data-js-date-format"))
  $scope.totalKarmaToAdd = 0

  $("body").on("click", ".add-more-hours li", function() {
    var lastHoursRow = $(".hours-month-year-entry").last()
    $(this).parents(".add-more-hours").siblings(".hours-month-year-holder").append(lastHoursRow.clone())

    $(".hours-month-year-entry").last().find(".hours").val("")

    toggleLastX($(this), "add")
  })

  $("body").on("click", ".close-icon", function() {
    var parent = $(this).parents(".hours-month-year-holder")
    $(this).parents(".hours-month-year-entry").remove()
    toggleLastX(parent, "remove")
  })

  $("body").on("click", ".add-karma-main-button", function(e) {
    e.preventDefault();
    var individualEntryFields = $(".individual-hours-entry-fields:visible")
    var hoursEntries = $(".hours-month-year-entry:visible")
    var errors = []
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
      } else if (!isEmail(contactEmail.val().trim())) {
        errors.push({
          ele: contactEmail,
          message: "not an email"
        })
      }
    };

    var allErrors = hoursValidation(hoursEntries, errors)

    if (allErrors.length > 0) {
      displayErrors(allErrors)
    } else {
      $(".edit_user").submit();
    }
  })

  function displayErrors(errors) {
    for (var i = 0; i < errors.length; i++) {
      var errorDiv = errors[i].ele.siblings(".error")
      if (errorDiv.length == 0) {
        errors[i].ele.parents(".holder-for-error-box").find(".error").append("<small class='js-added-error'>" + errors[i].message + "</small>")
      } else {
        errorDiv.append("<small class='js-added-error'>" + errors[i].message + "</small>")
      }
    };
    $('html, body').animate({
      scrollTop: errors[0].ele.offset().top - 30 + 'px'
    }, 'fast');
  }

  $("body").on("change", ".existing-dropdown", function() {
    var ele = $(this).find("option:selected")
    updateWithDropdown(ele)
  })

  $("body").on("click", ".toggle-existing", function() {
    $(this).siblings(".toggle-new").removeClass("active")
    $(this).addClass("active")
    $(this).parents(".verifier-nav").siblings(".new-hours-entry-fields").hide()
    var entryHolder = $(this).parents(".verifier-nav").siblings(".existing-hours-entry-holder")
    entryHolder.show()

    var ele = entryHolder.find(".existing-dropdown option:selected")
    updateWithDropdown(ele)
  })

  $("body").on("click", ".toggle-new", function() {
    addNewVerifier($(this))
  })

  function updateWithDropdown(ele) {
    var name = ele.attr("data-contact-name")
    var position = ele.attr("data-contact-position")
    var phone = ele.attr("data-contact-phone")
    var email = ele.attr("data-contact-email")

    ele.parents(".existing-dropdown").siblings(".verifier-details").find(".contact-position").text(position)
    ele.parents(".existing-dropdown").siblings(".verifier-details").find(".contact-phone").text(phone)
    ele.parents(".existing-dropdown").siblings(".verifier-details").find(".contact-email").text(email)

    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_name").find("input").val(name)
    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_position").find("input").val(position)
    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_phone").find("input").val(phone)
    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_email").find("input").val(email)
  }

  function addNewVerifier(ele) {
    var hoursEntryFields = ele.parents(".verifier-holder").find(".new-hours-entry-fields")
    hoursEntryFields.find(".user_hours_entries_contact_name").find("input").val("")
    hoursEntryFields.find(".user_hours_entries_contact_position").find("input").val("")
    hoursEntryFields.find(".user_hours_entries_contact_phone").find("input").val("")
    hoursEntryFields.find(".user_hours_entries_contact_email").find("input").val("")
    hoursEntryFields.siblings(".verifier-nav").find(".toggle-existing").removeClass("active")
    hoursEntryFields.siblings(".verifier-nav").find(".toggle-new").addClass("active")
    hoursEntryFields.siblings(".existing-hours-entry-holder").hide()
    hoursEntryFields.show()
  }

  function syncHoursFields() {
    setInterval(function() { updateHiddenDates(); }, 500);
  }

  function updateHiddenDates() {
    var dates = []
    var hoursEntries = $(".hours-month-year-entry")
    for (var i = 0; i < hoursEntries.length; i++) {
      var hours = $(hoursEntries[i]).find(".hours").val()
      dates.push(
        hours + "-" + $(hoursEntries[i]).find("#date_month").val() + "-" + $(hoursEntries[i]).find("#date_year").val()
      )
      $(hoursEntries[i]).siblings(".user_hours_entries_dates").find(".hidden-hours-entry-dates-field").val(dates.join(", "))

      // Clear dates array if going to another hours entry
      if ($(hoursEntries[i]).is(':last-child')) {
        dates = []
      }
    };
  }

  function toggleLastX(ele, type) {
    if (type == "add") {
      var hoursEntries = ele.parents(".add-more-hours").siblings(".hours-month-year-holder").find(".hours-month-year-entry")
    } else {
      var hoursEntries = ele.find(".hours-month-year-entry")
    }

    // If the close icon has already been removed
    if (hoursEntries.length == 1) {
      for (var i = 0; i < hoursEntries.length; i++) {
        $(hoursEntries[i]).find(".close-icon").hide()
      };
    } else {
      for (var i = 0; i < hoursEntries.length; i++) {
        $(hoursEntries[i]).find(".close-icon").show()
      };
    }
  }

  $(document).on('nested:fieldAdded', function(event){
    var ele = $(event.target).find(".existing-dropdown option:selected")
    updateWithDropdown(ele)

    $(".nonprofit-name-autocomplete").on('autocompleteresponse', function(event, ui) {
      var content;
      if (((content = ui.content) != null ? content[0].id.length : void 0) === 0) {
        $(this).autocomplete('close');
      }
    });
  })

  var isEmail = function(email) {      
    var emailReg = /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i;
    return emailReg.test(email);
  }

  $("body").on("keyup", ".hours", function() {
    var hoursEntries = $(".hours-month-year-entry:visible")
    var hoursExchangeRate = parseInt($(".add-hours-form").attr("data-hours-exchange-rate"))
    var sum = 0

    $(".js-added-error").remove()
    var errorsHolder = []
    var errors = hoursValidation(hoursEntries, errorsHolder)

    if (errors.length > 0) {
      displayErrors(errors)
    } else {
      for (var i = 0; i < hoursEntries.length; i++) {
        sum += parseInt($(hoursEntries[i]).find(".hours").val()) * hoursExchangeRate
      };
      $(".total-karma-to-add").text(sum)
    }
  })

  function hoursValidation(hoursEntries, errors) {
    for (var i = 0; i < hoursEntries.length; i++) {
      var hoursElement = $(hoursEntries[i]).find(".hours")
      var hours = hoursElement.val().trim()
      if (isNaN(hours) || hours == "") {
        errors.push({
          ele: hoursElement,
          message: "please fill in"
        })
      } else if (parseInt(hours) < 0) {
        errors.push({
          ele: hoursElement,
          message: "be positive"
        })
      } else if (hours % 1 != 0) {
        errors.push({
          ele: hoursElement,
          message: "no decimals"
        })
      }
    };
    return errors
  }
}]);















