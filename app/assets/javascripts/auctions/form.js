$(document).ready(function() {

  var rewards = 1;

  $( "#auction_start" ).datepicker({
    defaultDate: "+1w",
    // changeMonth: true,
    numberOfMonths: 1,
    dateFormat: "M d, yy (D)",
    onClose: function( selectedDate ) {
      $("#auction_end").datepicker( "option", "minDate", selectedDate );
    }
  });

  $( "#auction_end" ).datepicker({
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
      $(".add-a-reward").toggle();
      $(".mobile-add-a-reward").toggle();
    } else if (rewards == 2) {
      $(".reward-close").toggle();
      event.field.children().children().children(".reward-close").toggle()
    }
  });

  $("body").on('nested:fieldRemoved', function(event){
    event.field.remove();
    rewards -= 1;
    reNumberRewards();
    if (rewards == 2) {
      $(".add-a-reward").toggle();
      $(".mobile-add-a-reward").toggle();
    } else if (rewards == 1) {
      $(".reward-close").toggle();
    }
  });

  $(".reward-count").text("Reward #1"); // Set initial reward to number 1
  $(".reward-close").toggle(); // Cannot remove the first reward

  var reNumberRewards = function (){
    var rewardCounts = $(".reward-count");
    for (var i = 0; i < rewardCounts.length; i++) {
      $(rewardCounts[i]).text("Reward #" + (i + 1));
    };
  }
});