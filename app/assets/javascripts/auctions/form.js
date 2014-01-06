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
      // $("#auction_start").datepicker( "option", "maxDate", selectedDate );
      $("#auction_volunteer_end_date").datepicker( "option", "minDate", selectedDate );
    }
  });

  $("#auction_volunteer_end_date").datepicker({
    defaultDate: "+1w",
    // changeMonth: true,
    numberOfMonths: 1,
    dateFormat: "M d, yy (D)",
    // onClose: function( selectedDate ) {
    //   $("#auction_end").datepicker( "option", "maxDate", selectedDate );
    // }
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

  var auctionStart = $("#auction_start").val();
  var auctionEnd = $("#auction_end").val();
  var auctionVolunteerEnd = $("#auction_volunteer_end_date").val();

  if (auctionStart != "" && auctionStart != undefined) {
    // $("#auction_end").datepicker( "option", "minDate", auctionStart );
    $("#auction_start").val(auctionStart);
    reformatDate($("#auction_start"));
  } else {
    $("#auction_start").datepicker( "option", "minDate", new Date() );
  }
  if (auctionEnd != "" && auctionEnd != undefined) {
    // $("#auction_start").datepicker( "option", "maxDate", auctionEnd );
    // $("#auction_volunteer_end_date").datepicker( "option", "minDate", auctionEnd );
    // $("#auction_end").val(auctionEnd);
    reformatDate($("#auction_end"));
  }
  if (auctionVolunteerEnd != "" && auctionVolunteerEnd != undefined) {
    // $("#auction_end").datepicker( "option", "maxDate", auctionVolunteerEnd );
    reformatDate($("#auction_volunteer_end_date"));
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
    $('.reward-holder-column').syncHeight({ 'updateOnResize': true});
  });
  // and to undo the syncing again run (here when the window is smaller than 500px): 
  $(window).resize(function(){
    if($(window).width() < 500){
      $('.reward-holder-column').unSyncHeight();
    }
  });

  (function($) {
    $.fn.extend( {
      limiter: function(limit, elem) {
        $(this).on("keyup focus", function() {
            setCount(this, elem);
        });
        function setCount(src, elem) {
          var chars = src.value.length;
          if (chars > limit) {
            src.value = src.value.substr(0, limit);
            chars = limit;
          }
          elem.html( limit - chars + " characters left");
        }
        setCount($(this)[0], elem);
      }
    });

    if ($("#auction_short_description").length > 0) {
      var elem = $("#chars");
      $("#auction_short_description").limiter(140, elem);
    }

  })(jQuery);
});
