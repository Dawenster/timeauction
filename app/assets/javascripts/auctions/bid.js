$(document).ready(function() {
  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    $(this).addClass("disabled");
    $(this).removeClass("commit-button");
    $(this).val("Committing");
    $(".commit-clock-loader").toggle();

    if ($(".first-name").val() != "" && $(".last-name").val() != "") {
      var firstName = null;
      var lastName = null;
      var useStoredHours = $("#use-volunteer-hours").is(':checked');

      if ($(".name-field").length > 0) {
        firstName = $(".first-name").val();
        lastName = $(".last-name").val();
      }

      var hoursEntryData = $('#new_hours_entry').serializeArray();
      hoursEntryData.push({
        name: "hours_entry[amount]",
        value: $("#bid-amount-input").val()
      });
      hoursEntryData.push({
        name: "auction_id",
        value: $("#new_hours_entry").attr("data-auction-id")
      });

      var bidData = $('#new_bid').serializeArray();
      bidData.push({
        name: "first_name",
        value: firstName
      });
      bidData.push({
        name: "last_name",
        value: lastName
      });
      bidData.push({
        name: "use_stored_hours",
        value: useStoredHours
      });
      bidData.push({
        name: "reward_id",
        value: $('#new_bid').attr("data-reward-id")
      });
      
      $.when(

        $.post($('#new_hours_entry').attr("action"), hoursEntryData),
        $.post($('#new_bid').attr("action"), bidData)

      ).then(function(data) {

        var responseData = null;

        for (var i = 0; i < data.length; i++) {
          if (!(typeof data[i].url === 'undefined')) {
            responseData = data[i];
          }
        };

        if (responseData.fail) {
          $.cookie('just-bid', false, { path: '/' });
        } else {
          $.cookie('just-bid', true, { path: '/' });
        }
        window.location = responseData.url;

      });

    } else {

      $(".commit-clock-loader").toggle();
      $(this).removeClass("disabled");
      $(this).addClass("commit-button");
      $(".error").remove();
      var nameFields = $(".name-field");
      for (var i = 0; i < nameFields.length; i++) {
        if ($(nameFields[i]).val() == "") {
          $(nameFields[i]).after("<small class='error'>Please fill in</small>");
        }
      }
    }
  });
});