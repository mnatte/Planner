(function() {
  var RGroupBy, RMoveItem, RTeamMember, root,
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
              console.log("add set with label " + item[property] + " and groupedBy " + property);
              this.sets.push({
                label: item[property],
                items: [],
                groupedBy: property
              });
              addedSets.push("" + property + "_" + item[property]);
              console.log(addedSets);
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
            set.items.push(item);
            _results.push(console.log("added " + item + " to set " + set.label));
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

  root.RMoveItem = RMoveItem;

  root.RGroupBy = RGroupBy;

  root.RTeamMember = RTeamMember;

}).call(this);
