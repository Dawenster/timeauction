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
    var confirmFields = fetchConfirmFields()
    return confirmFields.firstName != "" && confirmFields.lastName != "" && confirmFields.phoneNumber != ""
  }

  function fetchConfirmFields() {
    return {
      isSignedIn: $(".confirm-step-holder").attr("data-is-signed-in"),
      firstName: $(".first-name").val(),
      lastName: $(".last-name").val(),
      email: $("input.name-field.email").val(),
      password: $("input.name-field.password").val()
    }
  }

  function loadBidData(scope) {
    var confirmFields = fetchConfirmFields()
    var bidData = [];
    bidData.push({
      name: "hours_bid",
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

  Bids.isEmail = function(email) {
    var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
  }

  return Bids;
}]);