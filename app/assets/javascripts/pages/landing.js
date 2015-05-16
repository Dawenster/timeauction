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

  $(".featured-auctions-orbit").on("ready.fndtn.orbit", function(event) {
    $(".featured-auctions-orbit").fadeIn()
  });
});






















