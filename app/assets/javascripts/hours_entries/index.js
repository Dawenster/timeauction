$(document).ready(function() {
  $(document).on("click", ".hours-entry-row", function() {
    window.location = $(this).attr("data-link");
  });
});