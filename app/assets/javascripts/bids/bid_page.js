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
        break;

      case "few-words-next-button":
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
    var hours = parseInt($("#bid-amount-input").val());
    var minBid = parseInt($("#bid-amount-input").attr("data-min-bid"));

    if (isNaN(hours)) {
      if (!$("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      $("#bid-amount-input").siblings(".error").text("Please fill in");
      $('html,body').scrollTop(0);
      return false;
    } else if (hours < minBid) {
      if (!$("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      $("#bid-amount-input").siblings(".error").text("Minimum " + minBid + " hrs");
      $('html,body').scrollTop(0);
      return false;
    } else {
      if ($("#bid-amount-input").siblings(".error").is(":visible")) {
        $("#bid-amount-input").siblings(".error").toggle();
      }
      return true;
    }
  }
});