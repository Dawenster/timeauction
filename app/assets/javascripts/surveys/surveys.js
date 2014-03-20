$(document).ready(function() {
  $(document).on("click", ".survey-content-holder td", function() {
    $(".survey-content-holder td").removeClass("active");
    $(this).addClass("active");
  });

  $(document).on("click", ".survey-1", function() {
    var num = $(".survey-content-holder td.active").attr("data-num");
    _gaq.push(['_trackEvent', 'Survey', 'Volunteer satisfaction', 'User ID: ' + $(this).attr("data-user-id") + ', Value: ' + num]);
  });
});