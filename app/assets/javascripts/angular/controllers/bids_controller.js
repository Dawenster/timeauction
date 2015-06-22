var app = angular.module('timeauction');

app.controller('BidsCtrl', ['$scope', '$interval', 'Donations', 'VolunteerHours', function($scope, $interval, Donations, VolunteerHours) {

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

  // GENERAL =============================================================================================

  var minBid = parseInt($(".verify-step-holder").attr("data-min-bid"))
  var totalPoints = parseInt($(".karma-count").attr("data-total-karma"))
  $scope.amountToAdd = 0

  // ADD STEP ============================================================================================


  function validateAddStep() {
    var errors = []
    errors = VolunteerHours.fieldsValidation(errors)
    errors = VolunteerHours.hoursValidation(errors)
    errors = haveOrAddedMoreThanMininum(errors)
    if (errors.length == 0) {
      return true
    } else {
      VolunteerHours.displayErrors(errors)
      return false
    }
  }

  function haveOrAddedMoreThanMininum(errors) {
    var totalKarmaToAdd = $(".total-karma-to-add:visible").text()
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
      errors.push({
        ele: $(".min-karma-error"),
        message: "You need at least " + minBid + " Karma Points to bid - please add more by donating or logging volunteer hours"
      })
    }
    return errors
  }

  // VERIFY STEP ============================================================================================

  var interval = 0

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

  var isEmail = function(email) {      
    var emailReg = /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i;
    return emailReg.test(email);
  }

  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    if (!$(this).hasClass("disabled")) {
      var firstName = $(".first-name").val();
      var lastName = $(".last-name").val();
      var phoneNumber = $(".phone-number").val();

      if (firstName != "" && lastName != "" && phoneNumber != "") {
        $(this).addClass("disabled");
        $(this).removeClass("commit-button");
        $(this).val("Bidding...");
        $(".commit-clock-loader").toggle();

        debugger
        
        callToCreateBid(loadBidData(firstName, lastName, phoneNumber));

      } else {

        $(".error").remove();

        var firstErrorPosition = null;
        var nameFields = $(".name-field");
        for (var i = 0; i < nameFields.length; i++) {
          if ($(nameFields[i]).val() == "") {
            $(nameFields[i]).after("<small class='error' style='height: 20px; padding: 10px; margin-top: -17px;'>Please fill in</small>");
            if (!firstErrorPosition) {
              firstErrorPosition = $(nameFields[i]).offset().top - 30;
            }
          }
        }
        $('html,body').scrollTop(firstErrorPosition);
      }
    }
  });

  function loadBidData(firstName, lastName, phoneNumber) {
    var bidData = [];
    bidData.push({
      name: "hours_bid",
      value: $scope.bidAmount
    });
    bidData.push({
      name: "first_name",
      value: firstName
    });
    bidData.push({
      name: "last_name",
      value: lastName
    });
    bidData.push({
      name: "phone_number",
      value: phoneNumber
    });
    bidData.push({
      name: "reward_id",
      value: $(".bid-page-holder").attr("data-reward-id")
    });
    bidData.push({
      name: "hk_domain",
      value: $(".bid-page-holder").attr("data-hk")
      // value: true
    });
    return bidData
  }

  function callToCreateBid(bidData) {
    $.ajax({
      url: $(".bid-page-holder").attr("data-url"),
      method: "post",
      data: bidData
    })
    .done(function(data) {
      if (data.fail) {
        $.cookie('just-bid', false, { path: '/' });
      } else {
        $.cookie('just-bid', true, { path: '/' });
      }
      window.location = data.url;
    })
  }
}]);