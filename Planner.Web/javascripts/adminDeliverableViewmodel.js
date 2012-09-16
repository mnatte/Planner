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
      this.createNewItem = __bind(this.createNewItem, this);      Deliverable.extend(RSimpleCrud);
      Deliverable.setSaveUrl("/planner/Deliverable/Save");
      Deliverable.setDeleteUrl("/planner/Deliverable/Delete");
      this.allActivities = ko.observableArray(allActivities);
      AdminDeliverableViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminDeliverableViewmodel.prototype.createNewItem = function(jsonData) {
      return Deliverable.create(jsonData);
    };

    AdminDeliverableViewmodel.prototype.createNewEmptyItem = function() {
      return new Deliverable(0, "", "", "", "");
    };

    return AdminDeliverableViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminDeliverableViewmodel = AdminDeliverableViewmodel;

}).call(this);
