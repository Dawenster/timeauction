$(document).ready(function() {
  // $(function(){
  //   $(".landing-type-replace").typed({
  //     strings: [
  //       " successful CEOs",
  //       " philanthropists",
  //       " community leaders",
  //       " kickass athletes",
  //       " badass founders",
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

  // Landing slider

  // var is_root = location.pathname == "/";
  // var firstAuctionId = $(".donors-slider-ul").attr("data-first-auction-id");

  // if (is_root) {
  //   $.ajax({
  //     url: "/donors_slider",
  //     data: {
  //       auctionId: firstAuctionId
  //     }
  //   });
  // }

  $(document).foundation({
    orbit: {
      slide_number: false,
      pause_on_hover: true,
      animation_speed: 500,
      timer_speed: 5000,
      navigation_arrows: true,
      bullets: false
    }
  });
  $(".donors-slider-ul").hide().fadeIn('slow');

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

  // setTimeout(function() {
  //   $(document).foundation('joyride', {
  //     expose: true,
  //     modal: true
  //   });
  //   $(document).foundation('joyride', 'start');
  // }, 1000);
});






















