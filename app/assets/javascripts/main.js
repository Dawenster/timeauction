$(document).ready(function() {
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

  $('input, textarea').placeholder();
});