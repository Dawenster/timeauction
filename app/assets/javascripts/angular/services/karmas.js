var app = angular.module('timeauction');

app.factory("Karmas", [function() {
  var Karmas = {};

  Karmas.commaSeparateNumber = function(val) {
    while (/(\d+)(\d{3})/.test(val.toString())) {
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
    }
    return val;
  }

  return Karmas;
}]);