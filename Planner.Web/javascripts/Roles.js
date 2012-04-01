(function() {
  var RCrud, RGroupBy, RMoveItem, RTeamMember, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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
          var addedSets, grp, item, set, _i, _len, _ref, _results;
          addedSets = [];
          _results = [];
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
              var _j, _len2, _ref2, _results2;
              _ref2 = this.sets;
              _results2 = [];
              for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
                grp = _ref2[_j];
                if (grp.label === item[property] && grp.groupedBy === property) {
                  _results2.push(grp);
                }
              }
              return _results2;
            }).call(this))[0];
            _results.push(set.items.push(item));
          }
          return _results;
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

}).call(this);
