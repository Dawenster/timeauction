$(".nonprofit-name-autocomplete").on('autocompleteresponse', function(event, ui) {
  var content;
  if (((content = ui.content) != null ? content[0].id.length : void 0) === 0) {
    $(this).autocomplete('close');
  }
});