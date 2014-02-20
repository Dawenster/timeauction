$(document).ready(function() {
  $("body").on("click", ".commit-button", function(e) {
    e.preventDefault();
    $(this).addClass("disabled");

    if ($(".first-name").val() != "" && $(".last-name").val() != "") {
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
        $.cookie('just-bid', true);
        window.location = data.url;
      });
    } else {
      $(".error").remove();
      var nameFields = $(".name-field");
      for (var i = 0; i < nameFields.length; i++) {
        if ($(nameFields[i]).val() == "") {
          $(nameFields[i]).after("<small class='error'>Please fill in</small>");
        }
      }
    }

  });

});