var app = angular.module('timeauction');

app.controller('BidsCtrl', ['$scope', '$interval', 'Donations', 'VolunteerHours', 'Bids', function($scope, $interval, Donations, VolunteerHours, Bids) {

  // PROGRESS TRACKER ============================================================================================

  // var hk = $('.few-words-step-holder').attr("data-hk");
  var bidSteps = []
  bidSteps = [
    "#apply-progress-step",
    "#verify-progress-step",
    "#confirm-progress-step"
  ]

  // if (hk) {
  //   bidSteps = [
  //     "#apply-progress-step",
  //     "#confirm-progress-step"
  //   ]
  // } else {
  //   bidSteps = [
  //     "#apply-progress-step",
  //     "#verify-progress-step",
  //     "#confirm-progress-step"
  //   ]
  // }

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
        if ($scope.bids.karmaScope.orgSpecificBid) {
          if (validateAddStep(true)) {
            validated = true;
          }
        } else if (validateAddStep(false) && noDonationErrors()) {
          validated = true;
        }
        break;

      case "verify-next-button":
        if (checkVerifyDetailsEntered()) {
          setHoursInWords()
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

  // GENERAL =============================================================================================

  var minBid = parseInt($(".verify-step-holder").attr("data-min-bid").replace(",", ""))
  var totalPoints = parseInt($(".karma-count").attr("data-total-karma").replace(",", ""))
  $scope.amountToAdd = 0
  $scope.bids = Bids
  $scope.bidPage = true

  // ADD STEP ============================================================================================


  function validateAddStep(orgSpecific) {
    var errors = []
    if (!orgSpecific) {
      errors = VolunteerHours.fieldsValidation(errors)
      errors = VolunteerHours.hoursValidation(errors)
    }
    errors = haveOrAddedMoreThanMininum(errors)
    $(".js-added-error").remove()
    if (errors.length == 0) {
      var hoursEntries = $(".hours-month-year-entry:visible")
      $scope.bids.karmaScope.updateTotalKarma(hoursEntries)
      return true
    } else {
      VolunteerHours.displayErrors(errors)
      return false
    }
  }

  function haveOrAddedMoreThanMininum(errors) {
    var totalKarmaToAdd = $scope.bids.karmaScope.totalKarmaToAdd
    if (isNaN(totalKarmaToAdd)) {
      $scope.amountToAdd = 0
    } else {
      $scope.amountToAdd = parseInt(totalKarmaToAdd)
    }
    $scope.totalPlusAdditional = totalPoints + $scope.amountToAdd
    $scope.bidAmount = minBid
    resetToggles()
    $scope.$apply()
    if ($scope.totalPlusAdditional < minBid) {
      if ($scope.bids.karmaScope.orgSpecificBid) {
        errors.push({
          ele: $(".min-karma-error"),
          message: "You need at least " + minBid + " Karma Points to bid - please add more by logging volunteer hours"
        })
      } else {
        errors.push({
          ele: $(".min-karma-error"),
          message: "You need at least " + minBid + " Karma Points to bid - please add more by donating or logging volunteer hours"
        })
      }
    }
    return errors
  }

  function noDonationErrors() {
    return $(".custom-input-error").text() == ""
  }

  // VERIFY STEP ============================================================================================

  var interval = 0
  $scope.enterDraw = false // will only show in cases that are both webinar and draw

  resetToggles()

  function resetToggles() {
    addColor($(".hours-toggles").find(".fa-toggle-up"))
    greyOut($(".hours-toggles").find(".fa-toggle-down"))

    if (fixedBid()) {
      greyOut($(".hours-toggles").find(".fa-toggle-up"))
    }
  }

  function addHour() {
    if ($scope.bidAmount == minBid && !fixedBid()) {
      addColor($(".hours-toggles").find(".fa-toggle-down"))
    }

    if ($scope.bidAmount < maxBid()) {
      $scope.bidAmount += 1
      if ($scope.bidAmount == maxBid()) {
        greyOut($(".hours-toggles").find(".fa-toggle-up"))
      }
    }
  }

  function minusHour() {
    if ($scope.bidAmount == maxBid() && !fixedBid()) {
      addColor($(".hours-toggles").find(".fa-toggle-up"))
    }

    if ($scope.bidAmount > minBid) {
      $scope.bidAmount -= 1
      if ($scope.bidAmount == minBid) {
        greyOut($(".hours-toggles").find(".fa-toggle-down"))
      }
    }
  }

  $("body").on("mousedown touchstart", ".add-hour-toggle", function() {
    addHour()
    interval = $interval(addHour, 100)
  }).bind('mouseup mouseleave touchend', function() {
    $interval.cancel(interval)
  });

  $("body").on("mousedown touchstart", ".minus-hour-toggle", function() {
    minusHour()
    interval = $interval(minusHour, 100)
  }).bind('mouseup mouseleave touchend', function() {
    $interval.cancel(interval)
  });

  function addColor(ele) {
    ele.attr("style", "color: #EB7F00; cursor: pointer;")
  }

  function greyOut(ele) {
    ele.attr("style", "color: grey; cursor: default;")
  }

  function maxBid() {
    var currentMaxBid = parseInt($(".hours-remaining-count").attr("data-max-bid")) - parseInt($(".hours-remaining-count").attr("data-already-bid"))
    return Math.min($scope.totalPlusAdditional, currentMaxBid)
  }

  function fixedBid() {
    return minBid == maxBid()
  }

  // CONFIRM STEP ============================================================================================

  var checkVerifyDetailsEntered = function() {
    return $scope.bidAmount >= minBid && $scope.bidAmount <= maxBid()
  }

  var setHoursInWords = function() {
    var hours = $scope.bids.karmaScope.pointsFromHoursOnly / 10
    if (hours == 1) {
      $scope.hoursInWords = "1 hour"
    } else {
      $scope.hoursInWords = hours + " hours"
    }
    $scope.$apply()
  }

  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    if (!$(this).hasClass("disabled")) {

      if (commitButtonValidations()) {
        $(".error").remove();

        if ($scope.bids.karmaScope.showDonateSection) {
          if ($scope.bids.karmaScope.useExistingCard) {
            Donations.makeDonationCall(null, $scope.bids.karmaScope)
          } else {
            Donations.openHandler($scope.bids.karmaScope)
            e.preventDefault();
          }
        } else if ($scope.bids.karmaScope.showVolunteerSection) {
          Bids.showCommitLoader()
          VolunteerHours.submitHours($scope)
        } else {
          Bids.showCommitLoader()
          Bids.callToCreate($scope)
        }

      } else {

        commitButtonDisplayErrors()

      }
    }
  });

  function commitButtonValidations() {
    if (Bids.isSignedIn()) {
      return Bids.confirmFieldsFilledIn()
    } else {
      return Bids.confirmFieldsFilledIn() && Bids.isEmail(Bids.fetchEmail()) && Bids.passwordLongEnough(Bids.fetchPassword())
    }
  }

  function commitButtonDisplayErrors() {
    $(".error").remove();

    var firstErrorPosition = null;
    var nameFields = $(".name-field:visible");
    for (var i = 0; i < nameFields.length; i++) {
      if ($(nameFields[i]).val() == "") {
        $(nameFields[i]).after(confirmStepErrorCreator("Please fill in"));
        firstErrorPosition = setTopError(firstErrorPosition, $(nameFields[i]))
      }
    }

    if (!Bids.isSignedIn()) {
      if (Bids.fetchEmail() != "" && !Bids.isEmail(Bids.fetchEmail())) {
        $("input.name-field.email").after(confirmStepErrorCreator("Not an email"));
        firstErrorPosition = setTopError(firstErrorPosition, $("input.name-field.email"))
      }

      if (Bids.fetchPassword() != "" && !Bids.passwordLongEnough(Bids.fetchPassword())) {
        $("input.name-field.password").after(confirmStepErrorCreator("Password too short"));
        firstErrorPosition = setTopError(firstErrorPosition, $("input.name-field.password"))
      }
    }
    $('html,body').scrollTop(firstErrorPosition);
  }

  function confirmStepErrorCreator(text) {
    return "<small class='error' style='height: 20px; padding: 10px; margin-top: -17px;'>" + text + "</small>"
  }

  function setTopError(firstErrorPosition, ele) {
    if (!firstErrorPosition) {
      firstErrorPosition = ele.offset().top - 30;
    }
    return firstErrorPosition
  }
}]);