$(document).ready(function() {
  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    if (!$(this).hasClass("disabled")) {
      if ($(".first-name").val() != "" && $(".last-name").val() != "" && $(".phone-number").val() != "") {
        $(this).addClass("disabled");
        $(this).removeClass("commit-button");
        $(this).val("Bidding...");
        $(".commit-clock-loader").toggle();

        var firstName = null;
        var lastName = null;
        var phoneNumber = null;

        if ($(".name-field").length > 0) {
          firstName = $(".first-name").val();
          lastName = $(".last-name").val();
          phoneNumber = $(".phone-number").val();
        }

        // Pass in more bid data
        var bidData = $('#new_bid').serializeArray();
        bidData.push({
          name: "hours_bid",
          value: parseInt($(".hours-to-bid").text())
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
          value: $('#new_bid').attr("data-reward-id")
        });
        bidData.push({
          name: "hk_domain",
          value: $('#new_bid').attr("data-hk")
          // value: true
        });

        callToCreateBid(bidData);

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