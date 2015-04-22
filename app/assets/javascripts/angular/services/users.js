var app = angular.module('timeauction.services', []);

app.factory("Users", function() {
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

  return Users;
});