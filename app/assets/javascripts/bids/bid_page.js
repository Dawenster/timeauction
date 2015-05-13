$(document).ready(function() {
  var hk = $('.few-words-step-holder').attr("data-hk");
  var bidSteps = []

  if (hk) {
    bidSteps = [
      "#apply-progress-step",
      "#confirm-progress-step"
    ]
  } else {
    bidSteps = [
      "#apply-progress-step",
      "#verify-progress-step",
      "#confirm-progress-step"
    ]
  }

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
        if (checkVerifyDetailsEntered() && checkMinBid()) {
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
    var hours = $(".bid-hours-input").find(".numeric:visible");
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

    var errorBox = $(hoursElement).parent().parent().siblings(".error")

    if (isNaN(hours)) {
      errorBox.text("Please enter a number");
      showError(errorBox);
      errors = 1;
    } else if (hours <= 0) {
      errorBox.text("Positive numbers only");
      showError(errorBox);
      errors = 1;
    } else if (pureHours % 1 != 0) { // Check if it is a float
      errorBox.text("Whole numbers only");
      showError(errorBox);
      errors = 1;
    } else {
      if (errorBox.is(":visible")) {
        errorBox.toggle();
      }
    }
    return errors;
  }

  var checkMinBid = function() {
    $(".bid-sum-panel").siblings(".error").remove();
    var bid = parseInt($(".total-hours-bid-count").text());
    var minBid = parseInt($(".verify-step-holder").attr("data-min-bid"));
    if (bid < minBid) {
      $(".bid-sum-panel").after("<small class='error' style='margin-top: -20px;'>Bid must exceed minimum hours required</small>")
      return false;
    } else {
      return true;
    }
  }

  var showError = function(errorBox) {
    if (!errorBox.is(":visible")) {
      errorBox.toggle();
    }
  }

  var checkVerifyDetailsEntered = function() {
    var firstErrorPosition = null;

    var fieldHolders = $(".hours-entry-must-fill-in:visible");
    var fields = [];

    for (var i = 0; i < fieldHolders.length; i++) {
      var field = $(fieldHolders[i]).find("input.string");
      if (field.length > 0) {
        fields.push(field);
      } else {
        fields.push($(fieldHolders[i]).find("textarea.text"));
      }
    }

    var errorCount = 0;

    for (var i = 0; i < fields.length; i++) {
      $(fields[i]).siblings(".error").remove();
      if ($(fields[i]).val().trim() == "") {
        $(fields[i]).after("<small class='error' style='margin-top: -17px;'>Please fill in</small>")
        if (!firstErrorPosition) {
          firstErrorPosition = $(fields[i]).offset().top - 30;
        }
        errorCount += 1;
      } else if ($(fields[i]).hasClass("email") && !$(fields[i]).val().trim == "") {
        if (!isEmail($(fields[i]).val())) {
          $(fields[i]).after("<small class='error' style='margin-top: -17px;'>Please enter a valid email</small>")
          if (!firstErrorPosition) {
            firstErrorPosition = $(fields[i]).offset().top - 30;
          }
          errorCount += 1;
        }
      }
    };

    if (errorCount == 0) {
      return true;
    } else {
      $('html,body').scrollTop(firstErrorPosition);
      return false;
    }
  }

  var isEmail = function(email) {      
    var emailReg = /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i;
    return emailReg.test(email);
  }

  var checkFewWordsEntered = function() {
    $("#bid_application").siblings(".error").remove();

    var application = $("#bid_application").val();
    if (application) {
      application = application.trim()
    }

    if (application == "") {
      $("#bid_application").after("<small class='error' style='margin-top: -17px;'>Please fill in</small>");
      var firstErrorPosition = $("#bid_application").offset().top - 30;
      $('html,body').scrollTop(firstErrorPosition);
      return false;
    } else {
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
    $(".new_bid").find(".fields:hidden").remove(); // Remove hidden fields so db doesn't create blank records
    showHoursSum();
  });

  var numOrganizations = function() {
    return $(".bid_hours_entries_organization:visible").length
  }

  $("body").on("input", "input.numeric.integer", function() {
    showHoursSum();
  });

  var showHoursSum = function() {
    if (hoursEnteredCorrectly()) {
      var hours = $(".bid-hours-input").find(".numeric:visible");
      var sum = 0;
      for (var i=0; i < hours.length; i++) {
        sum += parseInt($(hours[i]).val());
      }
      $(".total-hours-bid-count").text(sum);
    } else {
      $(".total-hours-bid-count").html("<div style='font-size: 30px; color: red;'>Hours inputted incorrectly :(</div>");
    }
  }
});