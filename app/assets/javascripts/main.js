$(document).ready(function() {
  $("body").on("click", ".close-reveal-modal", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
  });

  $("body").on("click", ".reveal-modal-bg", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
  });
});