$(document).ready(function() {
  // $(function(){
  //   $(".retypeable").typed({
  //     strings: [
  //       " successful CEOs",
  //       " startup founders",
  //       " community leaders",
  //       " media personalities",
  //       " industry experts",
  //       " inspiring artists",
  //       " amazing people"
  //     ],
  //     typeSpeed: 0,
  //     typeSpeed: 20, // typing speed
  //     backDelay: 3000, // pause before backspacing
  //     loop: false,
  //     callback: function(){
  //       $("#typed-cursor").hide();
  //       $(".landing-banner-title h1").attr("style", "margin-right: 0px;");
  //     } // call function after typing is done
  //   });
  // });

  $(document).on("click", ".orbit-caption-area", function() {
    window.location = $(this).attr("data-url");
  });

  // Load images below the fold later
  setTimeout(function() {
    var image = new Image()
    image.src = "https://s3-us-west-2.amazonaws.com/timeauction/crowd.jpg"
    $(".landing-hours-count-background-image").attr("style", "background-image:url(" + image.src + ")");
  }, 1000);

  $(document).on("click", ".landing-learn-more-link", function(e) {
    e.preventDefault();
    scrollToLearnMore();
  });

  function scrollToLearnMore() {
    $(document.body).animate({
      'scrollTop': $("#how-it-works-section").offset().top
    }, 1000);
  }
});