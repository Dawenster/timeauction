var app = angular.module('timeauction');

app.factory("Users", [function() {
  var Users = {};

  Users.saveAbout = function(url, text) {
    $.ajax({
      url: url,
      method: "post",
      data: {
        aboutText: text
      }
    }).done(function(data) {
      return data
    })
  }

  Users.makeIntoParagraphs = function(description) {
    var cleanDescription = "<p>"
    var splitDescription = description.trim().split("\n")
    for (var i = 0; i < splitDescription.length; i++) {
      if (splitDescription[i] != "") {
        cleanDescription += splitDescription[i]
        if (i != (splitDescription.length - 1)) {
          cleanDescription += "<br>"
        }
      } else {
        cleanDescription += "</p><p>"
      }
    };
    cleanDescription += "<i class='fa fa-edit'></i></p>"
    return cleanDescription
  }

  return Users;
}]);