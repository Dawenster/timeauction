$(document).ready(function() {
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
});