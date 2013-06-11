(function() {
  var AdminEnvironmentViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminEnvironmentViewmodel = (function(_super) {

    __extends(AdminEnvironmentViewmodel, _super);

    function AdminEnvironmentViewmodel(allEnvironments) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Environment.extend(RSimpleCrud);
      Environment.setSaveUrl("/planner/Environment/Save");
      Environment.setDeleteUrl("/planner/Environment/Delete");
      AdminEnvironmentViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminEnvironmentViewmodel.prototype.createNewItem = function(jsonData) {
      return new Environment(jsonData.Id, jsonData.Name, jsonData.Description, jsonData.Location, jsonData.ShortName);
    };

    AdminEnvironmentViewmodel.prototype.createNewEmptyItem = function() {
      return new Environment(0, "", "", "", "");
    };

    return AdminEnvironmentViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminEnvironmentViewmodel = AdminEnvironmentViewmodel;

}).call(this);
