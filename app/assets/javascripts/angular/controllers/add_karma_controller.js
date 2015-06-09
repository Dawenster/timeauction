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
    var hoursEntries = $(".hours-month-year-entry")
    var errors = []
    $(".js-added-error").remove()
    for (var i = 0; i < hoursEntries.length; i++) {
      var hours = $(hoursEntries[i]).find(".hours").val().trim()
      if (isNaN(hours) || hours == "") {
        errors.push({
          ele: $(hoursEntries[i]),
          message: "please fill in"
        })
      } else if (parseInt(hours) < 0) {
        errors.push({
          ele: $(hoursEntries[i]),
          message: "be positive"
        })
      } else if (hours % 1 != 0) {
        errors.push({
          ele: $(hoursEntries[i]),
          message: "no decimals"
        })
      }
    };
    if (errors.length > 0) {
      for (var i = 0; i < errors.length; i++) {
        errors[i].ele.find(".hours").siblings(".error").append("<small class='js-added-error'>" + errors[i].message + "</small>")
      };
      $('html, body').animate({
        scrollTop: errors[0].ele.offset().top + 'px'
      }, 'fast');
    } else {
      $(".edit_user").submit();
    }
  })

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

    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_name").find("input").text(name)
    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_position").find("input").text(position)
    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_phone").find("input").text(phone)
    ele.parents(".existing-hours-entry-holder").siblings(".new-hours-entry-fields").find(".user_hours_entries_contact_email").find("input").text(email)
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
}]);















