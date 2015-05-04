var app = angular.module('timeauction');

app.controller('HoursEntryCtrl', ['$scope', "Nonprofits", function($scope, Nonprofits) {
  Nonprofits.syncFields()

  $scope.showNewFields = !($(".new-hours-entry-fields").attr("data-has-entries") == "true")
  $scope.canSelectAll = true
  $scope.lastMonth = new Date($(".month-selection").last().attr("data-js-date-format"))

  updateWithDropdown()

  $(".existing-dropdown").change(function() {
    updateWithDropdown()
  });

  $("body").on("click", ".month-selection", function() {
    if ($(this).hasClass("active")) {
      $(this).removeClass("active")
    } else {
      $(this).addClass("active")
    }
    updateHiddenDates()
  })

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

  $scope.addMonths = function() {
    for (var i = 1; i <= 12; i++) {
      $scope.lastMonth.setMonth($scope.lastMonth.getMonth() - 1)
      var index = $scope.lastMonth.getMonth()
      var div = "<div class='small-4 large-3 columns'><div class='month-selection'>" + getMonthName(index) + $scope.lastMonth.getFullYear() + "</div></div>"
      $(".date-selection-holder-row").append(div)
    };
  }

  function getMonthName(index) {
    var monthNames = ["Jan. ", "Feb. ", "Mar. ", "Apr. ", "May. ", "Jun. ", "Jul. ", "Aug. ", "Sep. ", "Oct. ", "Nov. ", "Dec. "]
    return monthNames[index]
  }

  $scope.changeAll = function(action) {
    var monthSections = $(".month-selection")
    for (var i = 0; i < monthSections.length; i++) {
      if (action == "select") {
        if (!$(monthSections[i]).hasClass("active")) {
          $(monthSections[i]).addClass("active")
        }
      } else {
        if ($(monthSections[i]).hasClass("active")) {
          $(monthSections[i]).removeClass("active")
        }
      }
    };
    $scope.canSelectAll = !$scope.canSelectAll
    updateHiddenDates()
  }

  function updateHiddenDates() {
    var monthSections = $(".month-selection.active")
    var monthsAsText = []
    for (var i = 0; i < monthSections.length; i++) {
      monthsAsText.push($(monthSections[i]).text())
    };
    $(".hidden-hours-entry-dates-field").val(monthsAsText.join(", "))
  }
}]);















