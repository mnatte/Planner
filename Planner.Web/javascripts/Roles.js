(function() {
  var RCrud, RGroupBy, RMoveItem, RSimpleCrud, RTeamMember, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    _this = this;

  root = typeof global !== "undefined" && global !== null ? global : window;

  RMoveItem = {
    move: function(source, target) {
      source.splice(source.indexOf(this), 1);
      return target.push(this);
    },
    extended: function() {
      return this.include({
        test: "extended with RMoveItem"
      });
    }
  };

  RGroupBy = {
    extended: function() {
      return this.include({
        sets: [],
        group: function(property, collection) {
          var addedSets, grp, item, set, _i, _len, _ref;
          addedSets = [];
          for (_i = 0, _len = collection.length; _i < _len; _i++) {
            item = collection[_i];
            if (_ref = "" + property + "_" + item[property], __indexOf.call(addedSets, _ref) < 0) {
              this.sets.push({
                label: item[property],
                items: [],
                groupedBy: property
              });
              addedSets.push("" + property + "_" + item[property]);
            }
            set = ((function() {
              var _j, _len2, _ref2, _results;
              _ref2 = this.sets;
              _results = [];
              for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
                grp = _ref2[_j];
                if (grp.label === item[property] && grp.groupedBy === property) {
                  _results.push(grp);
                }
              }
              return _results;
            }).call(this))[0];
            console.log(set);
            set.items.push(item);
          }
          return this.sets;
        }
      });
    }
  };

  RTeamMember = {
    extended: function() {
      return this.include({
        focusFactor: 0.8,
        roles: []
      });
    }
  };

  RCrud = {
    extended: function() {
      return this.include({
        save: function(url, jsonData, callback) {
          return $.ajax(url, {
            dataType: "json",
            data: jsonData,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + jsonData + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        "delete": function(url, callback) {
          return $.ajax(url, {
            type: "DELETE",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + url + " called succesfully");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX DELETE error: " + errorThrown);
            }
          });
        },
        get: function(url, callback) {
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
        }
      });
    }
  };

  RSimpleCrud = {
    setSaveUrl: function(url) {
      return _this.saveUrl = url;
    },
    setDeleteUrl: function(url) {
      return _this.deleteUrl = url;
    },
    setLoadUrl: function(url) {
      return _this.loadUrl = url;
    },
    extended: function() {
      return this.include({
        save: function(jsonData, callback) {
          return $.ajax(saveUrl, {
            dataType: "json",
            data: jsonData,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + jsonData + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        "delete": function(id, callback) {
          var url;
          url = deleteUrl + "/" + id;
          return $.ajax(url, {
            type: "DELETE",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + url + " called succesfully");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX DELETE error: " + errorThrown);
            }
          });
        },
        get: function(callback) {
          return $.ajax(loadUrl, {
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
        }
      });
    }
  };

  root.RMoveItem = RMoveItem;

  root.RGroupBy = RGroupBy;

  root.RTeamMember = RTeamMember;

  root.RCrud = RCrud;

  root.RSimpleCrud = RSimpleCrud;

}).call(this);
