var app = angular.module('timeauction');

app.factory("Roles", function() {
  var Roles = {};

  Roles.saveRoleDetails = function(url, roleId, title, description) {
    $.ajax({
      url: url,
      method: "post",
      data: {
        role_id: roleId,
        title: title,
        description: description
      }
    }).done(function(data) {
      return data
    })
  }

  return Roles;
});