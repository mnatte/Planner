(function() {
  var Ajax, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  Ajax = (function() {

    function Ajax() {
      $.ajaxSetup({
        beforeSend: function() {
          return $.blockUI({
            css: {
              border: 'none',
              padding: '15px',
              backgroundColor: '#000',
              '-webkit-border-radius': '10px',
              '-moz-border-radius': '10px',
              opacity: .5,
              color: '#fff'
            },
            message: '<img src="images/ajax-loader.gif" />'
          });
        },
        complete: function() {
          return setTimeout($.unblockUI, 200);
        }
      });
    }

    Ajax.prototype.loadRelease = function(releaseId, callback) {
      var url;
      url = "/planner/Release/GetReleaseById/" + releaseId;
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

    Ajax.prototype.getProjects = function(callback) {
      var url;
      url = "/planner/Project/GetProjects";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Projects data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX Releases error: " + status);
        }
      });
    };

    Ajax.prototype.getResources = function(callback) {
      var url;
      url = "/planner/Resource/GetItems";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Resources data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX Releases error: " + status);
        }
      });
    };

    Ajax.prototype.getDeliverables = function(callback) {
      var url;
      url = "/planner/Deliverable/GetItems";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Deliverables data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX Deliverables error: " + status);
        }
      });
    };

    Ajax.prototype.getActivities = function(callback) {
      var url;
      url = "/planner/Deliverable/GetAllActivities";
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Activities data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          return console.log("AJAX Deliverables error: " + status);
        }
      });
    };

    Ajax.prototype.getAssignedResources = function(phaseId, projectId, callback) {
      var url;
      url = "/planner/ResourceAssignment/Assignments/" + phaseId + "/" + projectId;
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Resource Assignments data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          console.log("AJAX Releases status: " + status);
          console.log("AJAX Releases XHR: " + XHR);
          return console.log("AJAX Releases errorThrown: " + errorThrown);
        }
      });
    };

    Ajax.prototype.getAssignedResourcesForDeliverable = function(phaseId, projectId, milestoneId, deliverableId, callback) {
      var url;
      url = "/planner/ResourceAssignment/Assignments/" + phaseId + "/" + projectId + "/" + milestoneId + "/" + deliverableId;
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Resource Assignments data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          console.log("AJAX Releases status: " + status);
          console.log("AJAX Releases XHR: " + XHR);
          return console.log("AJAX Releases errorThrown: " + errorThrown);
        }
      });
    };

    Ajax.prototype.getAssignedResourcesForRelease = function(phaseId, callback) {
      var url;
      url = "/planner/ResourceAssignment/Assignments/Release/" + phaseId;
      return $.ajax(url, {
        dataType: "json",
        type: "GET",
        success: function(data, status, XHR) {
          console.log("Resource Assignments data loaded");
          return callback(data);
        },
        error: function(XHR, status, errorThrown) {
          console.log("AJAX Releases status: " + status);
          console.log("AJAX Releases XHR: " + XHR);
          return console.log("AJAX Releases errorThrown: " + errorThrown);
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
