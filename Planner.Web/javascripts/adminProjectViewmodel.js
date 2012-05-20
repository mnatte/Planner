(function() {
  var AdminProjectViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminProjectViewmodel = (function() {

    function AdminProjectViewmodel(allProjects) {
      this.deleteProject = __bind(this.deleteProject, this);
      this.saveSelected = __bind(this.saveSelected, this);
      this.addProject = __bind(this.addProject, this);
      this.refreshProject = __bind(this.refreshProject, this);
      this.selectProject = __bind(this.selectProject, this);      Project.extend(RCrud);
      this.selectedProject = ko.observable();
      this.allProjects = ko.observableArray(allProjects);
      this.allProjects.sort();
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
    }

    AdminProjectViewmodel.prototype.selectProject = function(data) {
      console.log("selectProject - function");
      return this.selectedProject(data);
    };

    AdminProjectViewmodel.prototype.refreshProject = function(index, jsonData) {
      var i, proj;
      i = index >= 0 ? index : this.allProjects().length;
      this.allProjects.splice(i, 1);
      console.log(jsonData);
      if (jsonData !== null && jsonData !== void 0) {
        console.log("jsonData not undefined");
        proj = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch);
        return this.allProjects.splice(i, 0, proj);
      } else {
        return this.selectProject(this.allProjects()[0]);
      }
    };

    AdminProjectViewmodel.prototype.clear = function() {
      console.log("clear: selectedProject: " + (this.selectedProject().title));
      return this.selectProject(new Project(0, "", "", "", "", ""));
    };

    AdminProjectViewmodel.prototype.addProject = function(data) {
      return this.selectProject(new Project(0, "", "", "", "", "", data.id));
    };

    AdminProjectViewmodel.prototype.saveSelected = function() {
      var a, i, proj,
        _this = this;
      console.log("saveSelected: selectedProject: " + (this.selectedProject()));
      console.log(ko.toJSON(this.selectedProject()));
      proj = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allProjects();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedProject().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.allProjects().indexOf(proj);
      return this.selectedProject().save("/planner/Project/Save", ko.toJSON(this.selectedProject()), function(data) {
        return _this.refreshProject(i, data);
      });
    };

    AdminProjectViewmodel.prototype.deleteProject = function(data) {
      var a, i, id, proj,
        _this = this;
      proj = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allProjects();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === data.id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      id = data.id;
      i = this.allProjects().indexOf(proj);
      return proj["delete"]("/planner/Project/Delete/" + proj.id, function(callbackdata) {
        console.log(callbackdata);
        return _this.refreshProject(i);
      });
    };

    return AdminProjectViewmodel;

  })();

  root.AdminProjectViewmodel = AdminProjectViewmodel;

}).call(this);
