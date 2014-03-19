$(document).ready(function() {
  $(function(){
    $(".retypeable").typed({
      strings: [
        " successful CEOs",
        " startup founders",
        " community leaders",
        " media personalities",
        " industry experts",
        " inspiring artists",
        " amazing people"
      ],
      typeSpeed: 0,
      typeSpeed: 20, // typing speed
      backDelay: 3000, // pause before backspacing
      loop: false,
      callback: function(){
        $("#typed-cursor").hide();
        $(".landing-banner-title h1").attr("style", "margin-right: 0px;");
      } // call function after typing is done
    });
  });
});