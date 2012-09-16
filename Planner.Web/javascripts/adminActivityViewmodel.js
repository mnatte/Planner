(function() {
  var AdminActivityViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminActivityViewmodel = (function(_super) {

    __extends(AdminActivityViewmodel, _super);

    function AdminActivityViewmodel(allItems) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Activity.extend(RSimpleCrud);
      Activity.setSaveUrl("/planner/Deliverable/SaveActivity");
      Activity.setDeleteUrl("/planner/Deliverable/DeleteActivity");
      AdminActivityViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminActivityViewmodel.prototype.createNewItem = function(jsonData) {
      return new Activity(jsonData.Id, jsonData.Title, jsonData.Description);
    };

    AdminActivityViewmodel.prototype.createNewEmptyItem = function() {
      return new Activity(0, "", "");
    };

    return AdminActivityViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminActivityViewmodel = AdminActivityViewmodel;

}).call(this);
