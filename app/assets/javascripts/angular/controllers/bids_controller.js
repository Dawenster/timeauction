var app = angular.module('timeauction');

app.controller('BidsCtrl', ['$scope', 'Donations', 'VolunteerHours', function($scope, Donations, VolunteerHours) {

  // PROGRESS TRACKER ============================================================================================

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
        if (validateAddStep()) {
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

  // ADD STEP ============================================================================================

  function validateAddStep() {
    var errors = []
    errors = VolunteerHours.fieldsValidation(errors)
    errors = VolunteerHours.hoursValidation(errors)
    if (errors.length == 0) {
      return true
    } else {
      VolunteerHours.displayErrors(errors)
      return false
    }
  }

  // VERIFY STEP ============================================================================================

  var minBid = parseInt($(".verify-step-holder").attr("data-min-bid"))
  var currentMaxBid = parseInt($(".hours-remaining-count").attr("data-max-bid")) - parseInt($(".hours-remaining-count").attr("data-already-bid"))
  var maxBid = Math.min(parseInt($(".hours-remaining-count").text()), currentMaxBid)
  $scope.bidAmount = minBid
  greyOut($(".hours-toggles").find(".fa-toggle-down"))
  if (fixedBid()) {
    greyOut($(".hours-toggles").find(".fa-toggle-up"))
  }

  $scope.addHour = function() {
    if ($scope.bidAmount == minBid && !fixedBid()) {
      addColor($(".hours-toggles").find(".fa-toggle-down"))
    }

    if ($scope.bidAmount < maxBid) {
      $scope.bidAmount += 1
      if ($scope.bidAmount == maxBid) {
        greyOut($(".hours-toggles").find(".fa-toggle-up"))
      }
    }
  }

  $scope.minusHour = function() {
    if ($scope.bidAmount == maxBid && !fixedBid()) {
      addColor($(".hours-toggles").find(".fa-toggle-up"))
    }

    if ($scope.bidAmount > minBid) {
      $scope.bidAmount -= 1
      if ($scope.bidAmount == minBid) {
        greyOut($(".hours-toggles").find(".fa-toggle-down"))
      }
    }
  }

  function addColor(ele) {
    ele.attr("style", "color: #EB7F00; cursor: pointer;")
  }

  function greyOut(ele) {
    ele.attr("style", "color: grey; cursor: default;")
  }

  function fixedBid() {
    return minBid == maxBid
  }

  // BID STEP ============================================================================================

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
}]);