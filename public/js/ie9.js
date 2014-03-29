(function ( $ ) {
var width;
var csToggle = false;

$('.off-canvas-wrap').on('click', '.right-off-canvas-toggle, .exit-off-canvas', function() {
  width = (csToggle) ? 0 : 250;
  csToggle = (csToggle) ? false : true;

  $('#calendar-settings').animate({
    width: width+'px'
  });

  $('.main-section, .tab-bar').animate({
    left: '-'+width+'px'
  });
});
}( jQuery ));