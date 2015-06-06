var app = angular.module('timeauction');

app.controller('AddKarmaCtrl', ['$scope', "Nonprofits", function($scope, Nonprofits) {
  Nonprofits.syncFields()
  syncHoursFields()
  toggleLastX()

  $(".karma-count").stick_in_parent({parent: "body", bottoming: false})

  $scope.showDonateSection = false
  $scope.showVolunteerSection = false
  $(".new-hours-entry-holder").show() // So that users don't see the page in transition to hide certain sections


  $("body").on("click", ".add-more-hours li", function() {
    var lastHoursRow = $(".hours-month-year-entry").last()
    $(".hours-month-year-holder").append(lastHoursRow.clone())
    toggleLastX()
  })

  $("body").on("click", ".close-icon", function() {
    $(this).parents(".hours-month-year-entry").remove()
    toggleLastX()
  })

  $("body").on("click", ".submit-for-verification", function(e) {
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
      $('html,body').scrollTop(0);
    } else {
      $("#new_hours_entry").submit();
    }
  })

  $scope.showNewFields = !($(".new-hours-entry-fields").attr("data-has-entries") == "true")
  $scope.canSelectAll = true
  $scope.lastMonth = new Date($(".month-selection").last().attr("data-js-date-format"))

  updateWithDropdown()

  $(".existing-dropdown").change(function() {
    updateWithDropdown()
  });

  function updateWithDropdown() {
    var ele = $(".existing-dropdown option:selected")
    var name = ele.attr("data-contact-name")
    var position = ele.attr("data-contact-position")
    var phone = ele.attr("data-contact-phone")
    var email = ele.attr("data-contact-email")

    $(".contact-position").text(position)
    $(".contact-phone").text(phone)
    $(".contact-email").text(email)

    $("#hours_entry_contact_name").val(name)
    $("#hours_entry_contact_position").val(position)
    $("#hours_entry_contact_phone").val(phone)
    $("#hours_entry_contact_email").val(email)
  }

  $scope.fillFields = function() {
    $scope.showNewFields = false
    updateWithDropdown()
  }

  $scope.clearFields = function() {
    $scope.showNewFields = true
    $("#hours_entry_contact_name").val("")
    $("#hours_entry_contact_position").val("")
    $("#hours_entry_contact_phone").val("")
    $("#hours_entry_contact_email").val("")
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
      $(".hidden-hours-entry-hours-field").val(hours)
    };
    $(".hidden-hours-entry-dates-field").val(dates.join(", "))
  }

  function toggleLastX() {
    var hoursEntries = $(".hours-month-year-entry")
    if (hoursEntries.length == 1) {
      $(".close-icon").hide()
    } else {
      $(".close-icon").show()
    }
  }
}]);















