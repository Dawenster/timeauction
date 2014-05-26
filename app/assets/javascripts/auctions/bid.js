$(document).ready(function() {
  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    $(this).addClass("disabled");
    $(this).removeClass("commit-button");
    $(this).val("Committing");
    $(".commit-clock-loader").toggle();

    if ($(".first-name").val() != "" && $(".last-name").val() != "" && $(".phone-number").val() != "") {
      var firstName = null;
      var lastName = null;
      var phoneNumber = null;
      var useStoredHours = $("#use-volunteer-hours").is(':checked');

      if ($(".name-field").length > 0) {
        firstName = $(".first-name").val();
        lastName = $(".last-name").val();
        phoneNumber = $(".phone-number").val();
      }

      // Pass in more hours entry data
      var hoursEntryData = $('#new_hours_entry').serializeArray();
      hoursEntryData.push({
        name: "hours_entry[amount]",
        value: $("#bid-amount-input").val()
      });
      hoursEntryData.push({
        name: "auction_id",
        value: $("#new_hours_entry").attr("data-auction-id")
      });

      // Pass in more bid data
      var bidData = $('#new_bid').serializeArray();
      bidData.push({
        name: "amount",
        value: $("#bid-amount-input").val()
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
        name: "use_stored_hours",
        value: useStoredHours
      });
      bidData.push({
        name: "reward_id",
        value: $('#new_bid').attr("data-reward-id")
      });
      bidData.push({
        name: "hk_domain",
        value: $('.few-words-step-holder').attr("data-hk")
      });

      // First create new hours entry unless user is premium and using stored hours
      
      if (useStoredHours) {
        callToCreateBid(bidData);
      } else {
        $.ajax({
          url: $('#new_hours_entry').attr("action"),
          method: "post",
          data: hoursEntryData
        })
        .done(function(data) {
          bidData.push({
            name: "hours_entry_id",
            value: data.hours_entry_id
          });

          callToCreateBid(bidData);
        })
      }

    } else {

      $(".commit-clock-loader").toggle();
      $(this).removeClass("disabled");
      $(this).addClass("commit-button");
      $(".error").remove();
      var nameFields = $(".name-field");
      for (var i = 0; i < nameFields.length; i++) {
        if ($(nameFields[i]).val() == "") {
          $(nameFields[i]).after("<small class='error' style='height: 20px; padding: 10px; margin-top: -17px;'>Please fill in</small>");
        }
      }
      $('html,body').scrollTop(0);
    }
  });

  var callToCreateBid = function(bidData) {
    $.ajax({
      url: $('#new_bid').attr("action"),
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
});