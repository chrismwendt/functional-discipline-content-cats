'use strict';
var request = require('superagent');

exports.get = function (url) {
  return function (failure) {
    return function (success) {
      return function () {
        request.get(url, function (err, result) {
          if (err) failure(err)();
          else success(result.body)();
        });
      };
    };
  };
};
