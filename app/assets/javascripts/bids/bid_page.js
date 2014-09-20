$(document).ready(function() {
  var bidSteps = [
    "#bid-progress-step",
    "#verify-progress-step",
    "#few-words-progress-step",
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
      case "bid-next-button":
        if (checkHoursAreEntered()) {
          validated = true;
        }
        break;

      case "verify-next-button":
        if (checkVerifyDetailsEntered()) {
          validated = true;
        }
        break;

      case "few-words-next-button":
        if (checkFewWordsEntered()) {
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

  var checkHoursAreEntered = function() {
    var hours = $("#bid-amount-input").val();
    var parsed_hours = parseInt($("#bid-amount-input").val());
    var minBid = parseInt($("#bid-amount-input").attr("data-min-bid"));
    var storedHours = parseInt($("#use-volunteer-hours").attr("data-hours-left-to-use"));
    var useStoredHours = $("#use-volunteer-hours").is(':checked');

    if (hours === "" || isNaN(hours)) {
      if (!$("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      $("#bid-amount-input").siblings(".error").text("Please fill in");
      $('html,body').scrollTop(0);
      return false;
    } else if (parsed_hours < minBid) {
      if (!$("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      $("#bid-amount-input").siblings(".error").text("Minimum " + minBid + " hrs");
      $('html,body').scrollTop(0);
      return false;
    } else if (useStoredHours && parsed_hours > storedHours) {
      if (!$("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      $("#bid-amount-input").siblings(".error").text("Cannot use more than your " + storedHours + " stored hours");
      $('html,body').scrollTop(0);
      return false;
    } else {
      if ($("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      return true;
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
    var emailReg = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
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
});