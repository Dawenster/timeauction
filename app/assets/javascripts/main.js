$(document).ready(function() {
  var shownDemo = localStorage.getItem('demo-explanation');
  if (!shownDemo) {
    $('#demo-explanation').foundation('reveal', 'open', '');
  }

  $("body").on("click", ".close-reveal-modal", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
  });

  $("body").on("click", ".reveal-modal-bg", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
    localStorage.setItem('demo-explanation', JSON.stringify(true));
  });

  $("body").on("click", ".demo-close", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
    localStorage.setItem('demo-explanation', JSON.stringify(true));
  });
});