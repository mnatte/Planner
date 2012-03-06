(function() {
  var RGroupBy, RMoveItem, root;

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
          var item, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = collection.length; _i < _len; _i++) {
            item = collection[_i];
            if (!(this.sets[item[property]] === void 0)) continue;
            console.log("add set with propertyValue: " + item[property]);
            this.sets[item[property]] = {};
            _results.push(this.sets.push({
              name: item[property],
              items: [],
              link: "#" + item[property]
            }));
          }
          return _results;
        }
      });
    }
  };

  root.RMoveItem = RMoveItem;

  root.RGroupBy = RGroupBy;

}).call(this);
