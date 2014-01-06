$(document).ready(function() {
  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    var firstName = null;
    var lastName = null;

    if ($(".name-field").length > 0) {
      firstName = $(".first-name").val();
      lastName = $(".last-name").val();
    }

    $.ajax({
      url: $(this).parent().attr("action"),
      method: "put",
      data: {
        first_name: firstName,
        last_name: lastName
      }
    })
    .done(function(data) {
      window.location = data.url;
    });
  });
});