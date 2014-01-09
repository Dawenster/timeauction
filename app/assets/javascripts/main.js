$(document).ready(function() {
  var shownDemo = localStorage.getItem('demo-explanation');
  if (!$.cookie('demo-explanation')) {
    $('#demo-explanation').foundation('reveal', 'open', '');
  }

  $("body").on("click", ".close-reveal-modal", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
  });

  $("body").on("click", ".reveal-modal-bg", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
    $.cookie('demo-explanation', true);
  });

  $("body").on("click", ".demo-close", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
    $.cookie('demo-explanation', true);
  });
});