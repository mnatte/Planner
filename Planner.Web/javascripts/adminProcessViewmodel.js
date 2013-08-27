(function() {
  var AdminProcessViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminProcessViewmodel = (function(_super) {

    __extends(AdminProcessViewmodel, _super);

    function AdminProcessViewmodel(allProcesses) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Process.extend(RSimpleCrud);
      Process.setSaveUrl("/planner/Process/Save");
      Process.setDeleteUrl("/planner/Process/Delete");
      AdminProcessViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminProcessViewmodel.prototype.createNewItem = function(jsonData) {
      return Process.create(jsonData);
    };

    AdminProcessViewmodel.prototype.createNewEmptyItem = function() {
      return Process.createEmpty();
    };

    return AdminProcessViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminProcessViewmodel = AdminProcessViewmodel;

}).call(this);
