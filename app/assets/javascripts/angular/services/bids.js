var app = angular.module('timeauction');

app.factory("Bids", function() {
  var Bids = {};

  Bids.callToCreate = function(bidData) {
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

  return Bids;
});