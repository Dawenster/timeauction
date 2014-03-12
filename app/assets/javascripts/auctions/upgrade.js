$(document).ready(function() {
  $("body").on("click", ".back-on-upgrade-payment", function() {
    $('#upgrade-account-modal').foundation('reveal', 'open', {});
  });

  $("body").on("click", ".no-thanks-on-premium", function() {
    $('#upgrade-account-modal').foundation('reveal', 'close', '');
  });

  $("body").on("click", ".upgrade-button", function() {
    $('#upgrade-payment-modal').foundation('reveal', 'open', {});
  });

  $("body").on("click", ".upgrade-payment-button", function() {
    $(".upgrade-payment-button").toggle();
    $(".have-you-upgraded-question").toggle();
    $(".yes-i-have-donated-button").toggle();
    $(".no-i-will-pass-button").toggle();
    $(".remove-after-upgrade").remove();
    $(".donate-explanation").text("Remember, if Time Auction does not receive your forwarded donation email within 24 hours you we will return your account to a General Account and cancel any Supporter Rewards you may have pledged to.");
  });

  $("body").on("click", ".yes-i-have-donated-button", function(e) {
    e.preventDefault();
    $(this).children("a").addClass("disabled");
    $(this).children("a").text("Upgrading");
    $(this).removeClass("yes-i-have-donated-button");
    $(".commit-clock-loader").toggle();
    $.ajax({
      url: $(this).attr("data-upgrade-path")
    })
    .done(function(data) {
      window.location = data.url;
    })
  });

  $("body").on("click", ".no-i-will-pass-button", function(e) {
    e.preventDefault();
    $('#upgrade-payment-modal').foundation('reveal', 'close', '');
  });

  $("body").on("click", "#canadian-red-cross", function(e) {
    e.preventDefault();
    var newUrl = "http://www.redcross.ca/donate";
    $("#american-red-cross").removeAttr("checked");
    $(".upgrade-payment-button").attr("href", newUrl);
    $(".donate-explanation").text("The 'Donate' button below will link to " + newUrl);
  });

  $("body").on("click", "#american-red-cross", function(e) {
    e.preventDefault();
    var newUrl = "https://www.redcross.org/quickdonate/index.jsp";
    $("#canadian-red-cross").removeAttr("checked");
    $(".upgrade-payment-button").attr("href", newUrl);
    $(".donate-explanation").text("The 'Donate' button below will link to " + newUrl);
  });
});