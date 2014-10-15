$(document).ready(function() {
  var bidSteps = [
    "#apply-progress-step",
    "#verify-progress-step",
    "#confirm-progress-step"
  ]

  $(document).on("click", ".step-circle-full", function() {
    var thisHolder = $(this).attr("data-this-holder");
    var goingHolder = $(this).attr("data-going-holder");

    if ($(thisHolder).is(":visible") || thisHolder == null) {
      return;
    } else {
      toggleStep(goingHolder);
      highlightUntilStep(bidSteps.indexOf($(this).attr("data-step")) + 1);
    }
  });

  $(document).on("click", ".bid-step-back-link", function() {
    var thisHolder = $(this).attr("data-this-holder");
    var goingHolder = $(this).attr("data-going-holder");

    if (thisHolder == null) {
      return;
    } else {
      toggleStep(goingHolder);
      highlightUntilStep(bidSteps.indexOf($(this).attr("data-step")) + 1);
    }
  });

  $(document).on("click", ".bid-step-next-button", function() {
    var validated = false;
    switch($(this).attr("id")) {
      case "apply-next-button":
        if (checkFewWordsEntered()) {
          validated = true;
        }
        break;

      case "verify-next-button":
        if (checkVerifyDetailsEntered()) {
          validated = true;
        }
        break;

      case "commit-button":
        break;
    }

    if (validated) {
      var thisHolder = $(this).attr("data-this-holder");
      var goingHolder = $(this).attr("data-going-holder");

      if (thisHolder == null) {
        return;
      } else {
        toggleStep(goingHolder);
        highlightUntilStep(bidSteps.indexOf($(this).attr("data-next-step")) + 1);
      }
    }
  });

  var toggleStep = function(step) {
    $(".step-holder").addClass("hide");
    $(step).removeClass("hide");
    $('html,body').scrollTop(0);
  }

  var clearHighlightedSteps = function() {
    $(".step-circle").removeClass("step-circle-full");
    $(".step-description-text").removeClass("step-description-text-full");
  }

  var highlightUntilStep = function(step) {
    clearHighlightedSteps();
    for (var i = 0; i < bidSteps.length; i++) {
      if (i == step) {
        return;
      } else {
        $(bidSteps[i]).addClass("step-circle-full");
        $(bidSteps[i] + " .step-description-text").addClass("step-description-text-full");
      }
    };
  }

  var hoursEnteredCorrectly = function() {
    var hours = $(".bid-hours-input");
    var errorCount = 0;

    for (var i=0; i < hours.length; i++) {
      errorCount += hoursErrorCheck(hours[i]);
    }

    if (errorCount == 0) {
      return true;
    } else {
      return false;
    }
  }

  var hoursErrorCheck = function(hoursElement) {
    var pureHours = $(hoursElement).val()
    var hours = parseInt(pureHours);
    var errors = 0;

    if (isNaN(hours)) {
      $(hoursElement).siblings(".error").text("Please enter a number");
      showError(hoursElement);
      errors = 1;
    } else if (hours <= 0) {
      $(hoursElement).siblings(".error").text("Positive numbers only");
      showError(hoursElement);
      errors = 1;
    } else if (pureHours % 1 != 0) { // Check if it is a float
      $(hoursElement).siblings(".error").text("Whole numbers only");
      showError(hoursElement);
      errors = 1;
    } else {
      if ($(hoursElement).siblings(".error").is(":visible")) {
        $(hoursElement).siblings(".error").toggle();
      }
    }
    return errors;
  }

  var showError = function(hoursElement) {
    if (!$(hoursElement).siblings(".error").is(":visible")) {
      $(hoursElement).siblings(".error").toggle();
    }
  }

  var checkVerifyDetailsEntered = function() {
    var fields = [
      "#hours_entry_organization",
      "#hours_entry_contact_name",
      "#hours_entry_contact_position",
      "#hours_entry_contact_phone",
      "#hours_entry_contact_email",
      "#hours_entry_description",
      "#hours_entry_dates"
    ];

    var errorCount = 0;
    
    for (var i = 0; i < fields.length; i++) {
      $(fields[i]).siblings(".error").remove();
      if ($(fields[i]).val().trim() == "") {
        $(fields[i]).after("<small class='error' style='margin-top: -17px;'>Please fill in</small>")
        errorCount += 1;
      }
      if (fields[i] == "#hours_entry_contact_email" && !$(fields[i]).val().trim == "") {
        if (!isEmail($(fields[i]).val())) {
          $(fields[i]).after("<small class='error' style='margin-top: -17px;'>Please enter a valid email</small>")
          errorCount += 1;
        }
      }
    };

    if (errorCount == 0) {
      return true;
    } else {
      return false;
    }
  }

  var isEmail = function(email) {      
    var emailReg = /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i;
    return emailReg.test(email);
  }

  var checkFewWordsEntered = function() {
    var application = $("#bid_application").val().trim();
    if (application == "") {
      $("#bid_application").after("<small class='error' style='margin-top: -17px;'>Please fill in</small>");
      return false;
    } else {
      $("#bid_application").siblings(".error").remove();
      return true;
    }
  }

  $("body").on('nested:fieldAdded', function(event){
    if (numOrganizations() > 1) {
      var removeLinks = $(".remove-organization-link");
      for (var i = 0; i < removeLinks.length; i++) {
        $(removeLinks[i]).removeClass("hide");
      }
    }
  });

  $("body").on('nested:fieldRemoved', function(event){
    if (numOrganizations() == 1) {
      var removeLinks = $(".remove-organization-link");
      for (var i = 0; i < removeLinks.length; i++) {
        $(removeLinks[i]).addClass("hide");
      }
    }
  });

  var numOrganizations = function() {
    return $(".bid_hours_entries_organization:visible").length
  }

  $("body").on("keyup", ".bid-hours-input", function() {
    if (hoursEnteredCorrectly()) {
      var hours = $(".bid-hours-input");
      var sum = 0;
      for (var i=0; i < hours.length; i++) {
        sum += parseInt($(hours[i]).val());
      }
      $(".total-hours-bid-count").text(sum);
    } else {
      $(".total-hours-bid-count").html("<div style='font-size: 30px; color: red;'>Hours inputted incorrectly :(</div>");
    }
  });
});