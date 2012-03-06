(function() {
  var RGroupBy, RMoveItem, root,
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
            if (_ref = item[property], __indexOf.call(addedSets, _ref) < 0) {
              this.sets.push({
                label: item[property],
                items: []
              });
              addedSets.push(item[property]);
            }
            set = ((function() {
              var _j, _len2, _ref2, _results2;
              _ref2 = this.sets;
              _results2 = [];
              for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
                grp = _ref2[_j];
                if (grp.label === item[property]) _results2.push(grp);
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

  root.RMoveItem = RMoveItem;

  root.RGroupBy = RGroupBy;

}).call(this);
