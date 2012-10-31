(function() {
  var AdminProjectViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminProjectViewmodel = (function(_super) {

    __extends(AdminProjectViewmodel, _super);

    function AdminProjectViewmodel(allProjects) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Project.extend(RSimpleCrud);
      Project.extend(RProjectSerialize);
      Project.setSaveUrl("/planner/Project/Save");
      Project.setDeleteUrl("/planner/Project/Delete");
      AdminProjectViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminProjectViewmodel.prototype.createNewItem = function(jsonData) {
      return new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch);
    };

    AdminProjectViewmodel.prototype.createNewEmptyItem = function() {
      return new Project(0, "", "", "", "", "");
    };

    return AdminProjectViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminProjectViewmodel = AdminProjectViewmodel;

}).call(this);
