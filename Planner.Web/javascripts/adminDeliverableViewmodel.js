(function() {
  var AdminDeliverableViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminDeliverableViewmodel = (function(_super) {

    __extends(AdminDeliverableViewmodel, _super);

    function AdminDeliverableViewmodel(allItems, allActivities) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);
      var del, _i, _len, _ref;
      Deliverable.extend(RSimpleCrud);
      Deliverable.setSaveUrl("/planner/Deliverable/Save");
      Deliverable.setDeleteUrl("/planner/Deliverable/Delete");
      this.allActivities = ko.observableArray(allActivities);
      AdminDeliverableViewmodel.__super__.constructor.apply(this, arguments);
      _ref = this.allItems();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        del = _ref[_i];
        this.setDeliverableActivities(del);
      }
    }

    AdminDeliverableViewmodel.prototype.createNewItem = function(jsonData) {
      var del;
      del = Deliverable.create(jsonData);
      this.setDeliverableActivities(del);
      return del;
    };

    AdminDeliverableViewmodel.prototype.createNewEmptyItem = function() {
      return new Deliverable(0, "", "", "", "");
    };

    AdminDeliverableViewmodel.prototype.setDeliverableActivities = function(del) {
      var a, act, delacts, _i, _len, _results;
      delacts = del.activities.slice();
      del.activities = ko.observableArray([]);
      _results = [];
      for (_i = 0, _len = delacts.length; _i < _len; _i++) {
        act = delacts[_i];
        _results.push((function() {
          var _j, _len2, _ref, _results2;
          _ref = this.allActivities();
          _results2 = [];
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            a = _ref[_j];
            if (a.id === act.id) _results2.push(del.activities.push(a));
          }
          return _results2;
        }).call(this));
      }
      return _results;
    };

    return AdminDeliverableViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminDeliverableViewmodel = AdminDeliverableViewmodel;

}).call(this);
