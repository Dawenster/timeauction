$(document).ready(function() {
  $(document).on("click", ".survey-satisfaction-holder td", function() {
    $(".survey-satisfaction-holder td").removeClass("active");
    $(this).addClass("active");
  });

  $(document).on("click", ".reason-button", function() {
    if ($(this).hasClass("active")) {
      $(this).removeClass("active");
    } else {
      $(this).addClass("active");
    }
  });

  $(document).on("click", ".survey-1", function() {
    var satisfactionLevel = $(".survey-satisfaction-holder td.active")
    if (optionSelected(satisfactionLevel)) {
      var num = satisfactionLevel.attr("data-num");
      _gaq.push(['_trackEvent', 'Survey', 'Volunteer satisfaction', 'User ID: ' + $(this).attr("data-user-id") + ', Value: ' + num]);
      toggleReasons();
    } else {
      alert("Please select a box");
    }
  });

  $(document).on("click", ".survey-2", function() {
    var userID = $(this).attr("data-user-id");
    var selected = $(".reason-button.active");
    var inputtedText = $(".survey-self-input").val();
    selected.push(inputtedText);

    if (optionSelected(selected)) {
      sendSelectedTexts(selected, userID);
      sendManuallyTypedText(inputtedText, userID);
      toggleAskEmail();
      $.cookie('finished_survey', true);
    } else {
      alert("Please select at least one box or enter a value in the field marked 'Other'");
    }
  });

  $(document).on("click", ".survey-3", function() {
    var email = $(".survey-email-input").val();
    if (validateEmail(email)) {
      var userID = $(this).attr("data-user-id");
      sendEmailPermission(email, userID);
      toggleThankYou();
      fadeOutSurvey();
    } else {
      alert("Please enter a valid email");
    }
  });

  var optionSelected = function(arr) {
    if (arr.length == 0) {
      return false
    } else {
      return true
    }
  }

  var sendSelectedTexts = function(selected, userID) {
    for (var i = 0; i < selected.length; i++) {
      if (!$(selected[i]).text() == "") {
        _gaq.push(['_trackEvent', 'Survey', 'Volunteer barrier', 'User ID: ' + userID + ', Value: ' + $(selected[i]).text()]);
      }
    }
  }

  var sendManuallyTypedText = function(inputtedText, userID) {
    if (inputtedText) {
      _gaq.push(['_trackEvent', 'Survey', 'Volunteer barrier', 'User ID: ' + userID + ', Value: ' + inputtedText]);
    }
  }

  var sendEmailPermission = function(email, userID) {
    var canUseEmail = $(".survey-use-my-email").is(':checked');
    if (email == "") {
      email = "Email not given";
    }
    _gaq.push(['_trackEvent', 'Survey', 'Further research', 'User ID: ' + userID + ', Can use email: ' + canUseEmail + ', Email: ' + email]);
  }

  var toggleReasons = function() {
    $(".survey-satisfaction-holder").toggle();
    $(".survey-hold-back-holder").toggle();
  }

  var toggleAskEmail = function() {
    $(".survey-hold-back-holder").toggle();
    $(".survey-ask-email").toggle();
  }

  var toggleThankYou = function() {
    $(".survey-ask-email").toggle();
    $(".survey-thank-you").toggle();
  }

  var validateEmail = function(email) { 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (re.test(email) || !$(".survey-use-my-email").is(':checked')) {
      return true;
    } else {
      return false;
    }
  }

  var fadeOutSurvey = function() {
    setTimeout(function() {
      $(".survey-holder").fadeTo("slow", 0.01, function() { //fade
        $(this).slideUp("slow", function() { //slide up
          $(this).remove(); //then remove from the DOM
        });
      });
    }, 2000);
  }
});