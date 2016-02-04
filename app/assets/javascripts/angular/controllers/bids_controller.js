var app = angular.module('timeauction');

app.controller('BidsCtrl', ['$scope', '$interval', 'Donations', 'VolunteerHours', 'Bids', 'Karmas', function($scope, $interval, Donations, VolunteerHours, Bids, Karmas) {

  // PROGRESS TRACKER ============================================================================================

  var hk = $(".bid-page-holder").data("hk");

  var bidSteps = []
  bidSteps = [
    "#apply-progress-step",
    "#verify-progress-step",
    "#confirm-progress-step"
  ]

  if ($(".org-select-checkbox").length == 0) {
    $(".commit-button").removeClass("disabled")
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
        if ($scope.bids.karmaScope.orgSpecificBid) {
          if (validateAddStep(true)) {
            validated = true;
          }
        } else if (validateAddStep(false) && noDonationErrors()) {
          validated = true;
        }
        break;

      case "verify-next-button":
        if (hk) {
          $(".error").addClass("hide")
          var errors = checkApplicationFieldsCompleted()
          if (errors.length == 0) {
            setHoursInWords()
            setApplicationQuestionsOnScope()
            validated = true;
          } else {
            for (var i = 0; i < errors.length; i++) {
              var errorBox = errors[i].siblings(".error")
              errorBox.find("small").text("please fill in")
              errorBox.removeClass("hide")
            };
          }

        } else {
          if (checkVerifyDetailsEntered()) {
            setHoursInWords()
            validated = true;
          }
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

  // if (hk) {
  //   var hoursExchangeRate = parseInt($(".add-hours-form").attr("data-hours-exchange-rate"))
  //   if (!isKarmaPage()) {
  //     var minBid = parseInt($(".verify-step-holder").attr("data-min-bid").replace(",", ""))
  //     var hoursToBid = Math.ceil(minBid / hoursExchangeRate)
  //     $(".total-karma-to-add").text(Karmas.commaSeparateNumber(hoursToBid * hoursExchangeRate))
  //   }
  //   $scope.bids.karmaScope.totalKarmaToAdd = hoursToBid * hoursExchangeRate
  //   $scope.bidAmount = $scope.bids.karmaScope.totalKarmaToAdd
  // }

  // function isKarmaPage() {
  //   return $(".add-hours-form").data("karma-page")
  // }

  // VERIFY STEP ============================================================================================

  var interval = 0
  $scope.enterDraw = false // will only show in cases that are both webinar and draw
  $scope.showStudentSection = false
  $scope.showWorkingSection = false

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

  var checkVerifyDetailsEntered = function() {
    return $scope.bidAmount >= minBid && $scope.bidAmount <= maxBid()
  }

  var checkApplicationFieldsCompleted = function() {
    errors = []
    if (!$("#occupationStudent").is(":checked") && !$("#occupationWorking").is(":checked")) {
      errors.push($("#occupationStudent"))
    }

    var inputAreas = $(".verify-step-holder .string-input:visible")
    for (var i = 0; i < inputAreas.length; i++) {
      if ($(inputAreas[i]).val() == "") {
        errors.push($(inputAreas[i]))
      }
    };

    var textareas = $(".verify-step-holder textarea:visible")
    for (var i = 0; i < textareas.length; i++) {
      if ($(textareas[i]).val() == "") {
        errors.push($(textareas[i]))
      }
    };

    if (!$('input[name=referral]:checked').val()) {
      errors.push($(".referral-holder"))
    }
    return errors
  }

  $scope.occupationClicked = function(event) {
    var button = $(event.target)
    if (button.is("#occupationStudent")) {
      $scope.showStudentSection = true
      $scope.showWorkingSection = false
    } else {
      $scope.showStudentSection = false
      $scope.showWorkingSection = true
    }
  }

  $scope.clickedOtherReferral = function() {
    $("#referral-other").prop("checked", true)
  }

  // CONFIRM STEP ============================================================================================

  var setHoursInWords = function() {
    var hours = $scope.bids.karmaScope.pointsFromHoursOnly / 10
    if (hours == 1) {
      $scope.hoursInWords = "1 hour"
    } else {
      $scope.hoursInWords = hours + " hours"
    }
    $scope.$apply()
  }

  var setApplicationQuestionsOnScope = function() {
    $scope.schoolField = $(".school-field").val()
    $scope.schoolYearField = $(".school-year-field").val()
    $scope.majorField = $(".major-field").val()
    $scope.occupationField = $(".occupation-field").val()
    $scope.backgroundField = $(".background-field").val()
    $scope.whyField = $(".why-field").val()
    $scope.questionsField = $(".questions-field").val()
    $scope.referralField = $('input[name=referral]:checked').val()
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
    } else {
      if ($(".org-fields-holder").length > 0) {
        $(".bid-process-boolean-error").show()
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