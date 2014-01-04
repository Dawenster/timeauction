$(document).ready(function() {

  var rewards = parseInt($(".rewards-list").attr("data-rewards-count"));
  var method = $(".rewards-list").attr("data-method");

  $("#auction_start").datepicker({
    defaultDate: "+1w",
    // changeMonth: true,
    numberOfMonths: 1,
    dateFormat: "M d, yy (D)",
    onClose: function( selectedDate ) {
      $("#auction_end").datepicker( "option", "minDate", selectedDate );
    }
  });

  $("#auction_end").datepicker({
    defaultDate: "+1w",
    // changeMonth: true,
    numberOfMonths: 1,
    dateFormat: "M d, yy (D)",
    onClose: function( selectedDate ) {
      $("#auction_start").datepicker( "option", "maxDate", selectedDate );
    }
  });

  $("body").on("click", ".limit-bidders", function() {
    $(this).parent().parent().siblings(".number-of-bidders").toggle();
  });

  $("body").on('nested:fieldAdded', function(event){
    rewards += 1;
    reNumberRewards();
    if (rewards == 3) {
      toggleAddAReward();
    } else if (rewards == 2) {
      $(".reward-close").toggle();
      event.field.children().children().children(".reward-close").toggle()
    }
  });

  $("body").on('nested:fieldRemoved', function(event){
    // event.field.remove();
    rewards -= 1;
    reNumberRewards();
    if (rewards == 2) {
      toggleAddAReward();
    } else if (rewards == 1) {
      $(".reward-close").toggle();
    }
  });

  var reNumberRewards = function (){
    var rewardCounts = $(".reward-count");
    var rewardCountsShowing = []
    for (var i = 0; i < rewardCounts.length; i++) {
      if ($(rewardCounts[i]).parent().parent().parent().attr("style") === undefined) {
        rewardCountsShowing.push(rewardCounts[i]);
      }
    };
    for (var i = 0; i < rewardCountsShowing.length; i++) {
      $(rewardCountsShowing[i]).text("Reward #" + (i + 1));
    };
  }

  var toggleAddAReward = function () {
    $(".add-a-reward-holder").toggle();
    $(".mobile-add-a-reward").toggle();
  }

  var removeLastReward = function () {
    $(".rewards-list").children(".fields").last().remove()
  }

  var toggleBiddersIfLimiting = function () {
    var bidCheckBoxes = $(".limit-bidders");
    for (var i = 0; i < bidCheckBoxes.length; i++) {
      if ($(bidCheckBoxes[i]).is(':checked')) {
        $(bidCheckBoxes[i]).parent().parent().siblings(".number-of-bidders").toggle();
      }
    };
  }

  var reformatDate = function (dateInput) {
    var dateElements = dateInput.val().split(" ");
    var formattedDate = dateElements[2] + " ";
    formattedDate += parseInt(dateElements[1]) + ", ";
    formattedDate += dateElements[3] + " (";
    formattedDate += dateElements[0].substring(0, dateElements[0].length - 1) + ")";
    dateInput.val(formattedDate);
  }

  if ($("#auction_start").val() != "" && $("#auction_start").val() != undefined) {
    reformatDate($("#auction_start"));
  }
  if ($("#auction_end").val() != "" && $("#auction_end").val() != undefined) {
    reformatDate($("#auction_end"));
  }
  toggleBiddersIfLimiting();
  reNumberRewards();
  if (rewards == 1) {
    $(".reward-close").toggle(); // Cannot remove the first reward
  } else if (rewards == 3) {
    toggleAddAReward();
  }

  if (method == "update" && $(".alert-box").length == 0) {
    removeLastReward();
  } else if ($(".alert-box").length == 1) {
    toggleAddAReward();
  }

  $(window).load(function(){
    $('.tier-holder-column').syncHeight({ 'updateOnResize': true});
  });
  // and to undo the syncing again run (here when the window is smaller than 500px): 
  $(window).resize(function(){
    if($(window).width() < 500){
      $('.tier-holder-column').unSyncHeight();
    }
  });
});