var app = angular.module('timeauction');

app.factory("Bids", [function() {
  var Bids = {};

  Bids.callToCreate = function(scope) {
    $.ajax({
      url: $(".bid-page-holder").attr("data-url"),
      method: "post",
      data: loadBidData(scope)
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

  Bids.confirmFieldsFilledIn = function() {
    var confirmFields = Bids.fetchConfirmFields()
    if (Bids.isSignedIn()) {
      return confirmFields.firstName != "" && confirmFields.lastName != ""
    } else {
      return confirmFields.firstName != "" && confirmFields.lastName != "" && confirmFields.email != "" && confirmFields.password != ""
    }
  }

  Bids.fetchConfirmFields = function() {
    return {
      isSignedIn: Bids.isSignedIn(),
      firstName: Bids.fetchFirstName(),
      lastName: Bids.fetchLastName(),
      email: Bids.fetchEmail(),
      password: Bids.fetchPassword()
    }
  }

  function loadBidData(scope) {
    var confirmFields = Bids.fetchConfirmFields()
    var bidData = [];
    bidData.push({
      name: "points_bid",
      value: scope.bidAmount
    });
    bidData.push({
      name: "enter_draw",
      value: scope.enterDraw
    });
    bidData.push({
      name: "is_signed_in",
      value: confirmFields.isSignedIn
    });
    bidData.push({
      name: "first_name",
      value: confirmFields.firstName
    });
    bidData.push({
      name: "last_name",
      value: confirmFields.lastName
    });
    bidData.push({
      name: "email",
      value: confirmFields.email
    });
    bidData.push({
      name: "password",
      value: confirmFields.password
    });
    bidData.push({
      name: "reward_id",
      value: $(".bid-page-holder").attr("data-reward-id")
    });
    bidData.push({
      name: "enter_draw",
      value: $("#enter_draw").val()
    });
    bidData.push({
      name: "hk_domain",
      value: $(".bid-page-holder").attr("data-hk")
      // value: true
    });
    bidData.push({
      name: "background_field",
      value: scope.backgroundField
    });
    bidData.push({
      name: "why_field",
      value: scope.whyField
    });
    bidData.push({
      name: "questions_field",
      value: scope.questionsField
    });
    bidData.push({
      name: "school_field",
      value: scope.schoolField
    });
    bidData.push({
      name: "school_year_field",
      value: scope.schoolYearField
    });
    bidData.push({
      name: "major_field",
      value: scope.majorField
    });
    bidData.push({
      name: "occupation_field",
      value: scope.occupationField
    });
    bidData.push({
      name: "referral_source_field",
      value: scope.referralField
    });
    return bidData
  }

  Bids.showCommitLoader = function() {
    $("#commit-button").addClass("disabled");
    $("#commit-button").removeClass("commit-button");
    $("#commit-button").text("Bidding...");
    $(".commit-clock-loader").toggle();
  }

  Bids.hideCommitLoader = function() {
    $("#commit-button").removeClass("disabled");
    $("#commit-button").addClass("commit-button");
    $("#commit-button").text("Bidding...");
    $(".commit-clock-loader").toggle();
  }

  Bids.fetchFirstName = function() {
    return $(".first-name").val()
  }

  Bids.fetchLastName = function() {
    return $(".last-name").val()
  }

  Bids.isEmail = function(email) {
    var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
  }

  Bids.fetchEmail = function() {
    return $("input.name-field.email").val()
  }

  Bids.passwordLongEnough = function(password) {
    if (password) {
      return password.length >= 8
    } else {
      return false
    }
  }

  Bids.fetchPassword = function() {
    return $("input.name-field.password").val()
  }

  Bids.isSignedIn = function() {
    return $(".confirm-step-holder").attr("data-is-signed-in") == "true"
  }

  return Bids;
}]);