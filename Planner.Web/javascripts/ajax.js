(function() {
  var Ajax, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  Ajax = (function() {

    function Ajax() {}

    Ajax.prototype.load = function(callback) {
      var url;
      url = "/planner/Release/GetRelease";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("AJAX data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX error: " + status);
        }
      });
    };

    Ajax.prototype.loadPhases = function(callback) {
      var url;
      url = "/planner/Phases/GetPhases";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Phases data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX Phases error: " + status);
        }
      });
    };

    Ajax.prototype.submitRelease = function(data) {
      var url;
      return url = "/planner/Release/Create";
    };

    Ajax.prototype.getReleaseSummaries = function(callback) {
      var url;
      url = "/planner/Release/GetReleaseSummaries";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Releases data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX Releases error: " + status);
        }
      });
    };

    Ajax.prototype.test = function() {
      return console.log("testing AJAX class");
    };

    return Ajax;

  })();

  root.Ajax = Ajax;

}).call(this);
