angular.module('shepherd.services', [])
.factory('logger', [ function() {
  var logIt;
  toastr.options = {
    "closeButton": true,
    "positionClass": "toast-bottom-right",
    "timeOut": "3000"
  };
  logIt = function(message, type) {
    return toastr[type](message);
  };
  return {
    log: function(message) {
      logIt(message, 'info');
    },
    logWarning: function(message) {
      logIt(message, 'warning');
    },
    logSuccess: function(message) {
      logIt(message, 'success');
    },
    logError: function(message) {
      logIt(message, 'error');
    }
  };
}])
.factory('Storage', function() {
  return {
    get: function(key) {
      var item = sessionStorage.getItem(key);
      try {
        return JSON.parse(item);
      }
      catch (e) {}
      return null;
    },
    // get with test for cache expirey
    fetch: function(key) {
      var expires = sessionStorage.getItem(key + '-timestamp');
      // console.info("cache expires: ", (expires - Date.now())/1000 )
      if (Date.now() > expires) return false;
      var item = sessionStorage.getItem(key);
      try {
        return JSON.parse(item);
      }
      catch (e) {}
      return false;
    },
    // optional cache max age, in seconds
    set: function(key, value, max_age) {
      var json = JSON.stringify(value);
      try {
        sessionStorage.setItem(key, json);
        if (typeof(max_age) != "undefined") {
          var expires = Date.now() + (max_age * 1000);
          sessionStorage.setItem(key + '-timestamp', expires);
        }
        return true;
      }
      catch (e) {}
      return false;
    },
    erase: function(key) {
      sessionStorage.removeItem(key);
    },
    flush : function() {
      sessionStorage.clear();
    }
  };
});