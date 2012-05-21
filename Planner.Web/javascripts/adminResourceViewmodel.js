(function() {
  var AdminResourceViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminResourceViewmodel = (function(_super) {

    __extends(AdminResourceViewmodel, _super);

    function AdminResourceViewmodel(allResources) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Resource.extend(RSimpleCrud);
      Resource.setSaveUrl("/planner/Resource/Save");
      Resource.setDeleteUrl("/planner/Resource/Delete");
      AdminResourceViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminResourceViewmodel.prototype.createNewItem = function(jsonData) {
      return new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber);
    };

    AdminResourceViewmodel.prototype.createNewEmptyItem = function() {
      return new Resource(0, "", "", "", "", "", "", "");
    };

    return AdminResourceViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminResourceViewmodel = AdminResourceViewmodel;

}).call(this);
