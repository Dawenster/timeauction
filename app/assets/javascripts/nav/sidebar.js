$(document).ready(function() {
  $("body").on("click", ".left-off-canvas-toggle", function() {
    $(".footer").toggle();
    $(".main-holder").attr("style", "position: absolute; height: 100%; width: 100%;");
  });

  $("body").on("click", ".exit-off-canvas", function() {
    setTimeout(function(){
      $(".footer").fadeToggle();
      $(".main-holder").removeAttr("style");
    }, 500 );
  });
});