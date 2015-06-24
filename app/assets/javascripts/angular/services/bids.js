var app = angular.module('timeauction');

app.factory("Bids", function() {
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
      firstName: $(".first-name").val(),
      lastName: $(".last-name").val(),
      phoneNumber: $(".phone-number").val()
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
      value: true
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
      name: "phone_number",
      value: confirmFields.phoneNumber
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

  Bids.showCommitLoader = function() {
    $("#commit-button").addClass("disabled");
    $("#commit-button").removeClass("commit-button");
    $("#commit-button").val("Bidding...");
    $(".commit-clock-loader").toggle();
  }

  Bids.hideCommitLoader = function() {
    $("#commit-button").removeClass("disabled");
    $("#commit-button").addClass("commit-button");
    $("#commit-button").val("Bidding...");
    $(".commit-clock-loader").toggle();
  }

  return Bids;
});