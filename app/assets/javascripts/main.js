$(document).ready(function() {
  var shownDemo = localStorage.getItem('demo-explanation');
  // if (!$.cookie('demo-explanation')) {
  //   $('#demo-explanation').foundation('reveal', 'open', '');
  // }

  $("body").on("click", ".close-reveal-modal", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
  });

  $("body").on("click", ".reveal-modal-bg", function(e) {
    e.preventDefault();
    $(".reveal-modal").foundation('reveal', 'close', '');
    // $.cookie('demo-explanation', true);
  });

  // $("body").on("click", ".demo-close", function(e) {
  //   e.preventDefault();
  //   $(".reveal-modal").foundation('reveal', 'close', '');
  //   $.cookie('demo-explanation', true);
  // });

  // Deep linking for Foundation Tabs

  setTimeout(function(){
    if(window.location.hash){
      $('dl.tabs dd a').each(function(){
        var tab = $(this).attr('href').split('#')[1];
        var hash = '#' + tab;
        var classOfHash = "." + tab;
        if(hash == window.location.hash){
          $(classOfHash).click();
        }
      });
    }
  }, 100);

  $('body').on('click', '.tabs dd a', function (event, tab) {
    $('html,body').scrollTop(0);
  });

  if ($.cookie('first_time_sign_in') == "true") {
    $('#select-school-modal').foundation('reveal', 'open', '');
    $.cookie('first_time_sign_in', false)
  }
});