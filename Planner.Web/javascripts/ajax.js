(function() {
  var Ajax, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  Ajax = (function() {

    function Ajax() {}

    Ajax.prototype.load = function(callback) {
      var url;
      url = "/Release/GetRelease";
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

    Ajax.prototype.test = function() {
      return console.log("testing AJAX class");
    };

    return Ajax;

  })();

  root.Ajax = Ajax;

}).call(this);
