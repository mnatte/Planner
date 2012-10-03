(function() {
  var AdminProjectViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminProjectViewmodel = (function(_super) {

    __extends(AdminProjectViewmodel, _super);

    function AdminProjectViewmodel(allProjects) {
      this.setItemToDelete = __bind(this.setItemToDelete, this);
      this.confirmDelete = __bind(this.confirmDelete, this);
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Project.extend(RSimpleCrud);
      Project.setSaveUrl("/planner/Project/Save");
      Project.setDeleteUrl("/planner/Project/Delete");
      this.itemToDelete = ko.observable();
      AdminProjectViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminProjectViewmodel.prototype.createNewItem = function(jsonData) {
      return new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch);
    };

    AdminProjectViewmodel.prototype.createNewEmptyItem = function() {
      return new Project(0, "", "", "", "", "");
    };

    AdminProjectViewmodel.prototype.confirmDelete = function() {
      return this.deleteItem(this.itemToDelete(), $.unblockUI());
    };

    AdminProjectViewmodel.prototype.setItemToDelete = function(item) {
      this.itemToDelete(item);
      return $.blockUI({
        css: {
          border: 'none',
          padding: '15px',
          backgroundColor: '#000',
          '-webkit-border-radius': '10px',
          '-moz-border-radius': '10px',
          opacity: .5,
          color: '#fff'
        },
        message: $('#question')
      });
    };

    return AdminProjectViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminProjectViewmodel = AdminProjectViewmodel;

}).call(this);
