(function() {
  var SimpleCrudViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  SimpleCrudViewmodel = (function() {

    function SimpleCrudViewmodel(allItems) {
      this.deleteItem = __bind(this.deleteItem, this);
      this.saveSelected = __bind(this.saveSelected, this);
      this.refreshItem = __bind(this.refreshItem, this);
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);
      this.selectItem = __bind(this.selectItem, this);      this.selectedItem = ko.observable();
      this.allItems = ko.observableArray(allItems);
      this.allItems.sort();
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
    }

    SimpleCrudViewmodel.prototype.selectItem = function(data) {
      return this.selectedItem(data);
    };

    SimpleCrudViewmodel.prototype.createNewItem = function(jsonData) {
      throw new Error('Abstract method createNewItem');
    };

    SimpleCrudViewmodel.prototype.createNewEmptyItem = function() {
      throw new Error('Abstract method createNewEmptyItem');
    };

    SimpleCrudViewmodel.prototype.refreshItem = function(index, jsonData) {
      var i, item;
      i = index >= 0 ? index : this.allItems().length;
      this.allItems.splice(i, 1);
      if (jsonData !== null && jsonData !== void 0) {
        item = this.createNewItem(jsonData);
        return this.allItems.splice(i, 0, item);
      } else {
        return this.selectItem(this.allItems()[0]);
      }
    };

    SimpleCrudViewmodel.prototype.clear = function() {
      return this.selectItem(this.createNewEmptyItem());
    };

    SimpleCrudViewmodel.prototype.saveSelected = function() {
      var a, i, item,
        _this = this;
      item = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allItems();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedItem().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.allItems().indexOf(item);
      return this.selectedItem().save(ko.toJSON(this.selectedItem()), function(data) {
        return _this.refreshItem(i, data);
      });
    };

    SimpleCrudViewmodel.prototype.deleteItem = function(data) {
      var a, i, id, item,
        _this = this;
      item = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allItems();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === data.id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      id = data.id;
      i = this.allItems().indexOf(item);
      return item["delete"](item.id, function(callbackdata) {
        return _this.refreshItem(i);
      });
    };

    return SimpleCrudViewmodel;

  })();

  root.SimpleCrudViewmodel = SimpleCrudViewmodel;

}).call(this);
