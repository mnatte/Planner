(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases, allProjects) {
      this.deleteRelease = __bind(this.deleteRelease, this);
      this.saveSelected = __bind(this.saveSelected, this);
      this.addPhase = __bind(this.addPhase, this);
      this.refreshRelease = __bind(this.refreshRelease, this);
      this.selectRelease = __bind(this.selectRelease, this);
      var rel, _fn, _i, _len, _ref;
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
      Release.extend(RCrud);
      this.selectedRelease = ko.observable();
      this.allReleases = ko.observableArray(allReleases);
      this.allProjects = ko.observableArray(allProjects);
      this.allNumbers = ko.observableArray([1, 2, 3, 4, 5]);
      this.testNumbers = ko.observableArray([]);
      _ref = this.allReleases();
      _fn = function(rel) {
        return rel.phases.sort(function(a, b) {
          if (a.startDate.date > b.startDate.date) {
            return 1;
          } else if (a.startDate.date < b.startDate.date) {
            return -1;
          } else {
            return 0;
          }
        });
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rel = _ref[_i];
        this.setReleaseProjects(rel);
        console.log(ko.isWriteableObservable(rel.projects));
        _fn(rel);
      }
      this.allReleases.sort(function(a, b) {
        if (a.startDate.date > b.startDate.date) {
          return 1;
        } else if (a.startDate.date < b.startDate.date) {
          return -1;
        } else {
          return 0;
        }
      });
    }

    AdminReleaseViewmodel.prototype.setReleaseProjects = function(rel) {
      var p, proj, relprojs, _i, _len, _results;
      relprojs = rel.projects.slice();
      rel.projects = ko.observableArray([]);
      _results = [];
      for (_i = 0, _len = relprojs.length; _i < _len; _i++) {
        proj = relprojs[_i];
        _results.push((function() {
          var _j, _len2, _ref, _results2;
          _ref = this.allProjects();
          _results2 = [];
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            p = _ref[_j];
            if (p.id === proj.id) _results2.push(rel.projects.push(p));
          }
          return _results2;
        }).call(this));
      }
      return _results;
    };

    AdminReleaseViewmodel.prototype.selectRelease = function(data) {
      console.log("selectRelease - function");
      this.selectedRelease(data);
      return console.log(this.selectedRelease().projects());
    };

    AdminReleaseViewmodel.prototype.refreshRelease = function(index, jsonData) {
      var i, phase, project, rel, _i, _j, _len, _len2, _ref, _ref2;
      i = index >= 0 ? index : this.allReleases().length;
      this.allReleases.splice(i, 1);
      console.log(jsonData);
      if (jsonData !== null && jsonData !== void 0) {
        console.log("jsonData not undefined");
        rel = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath);
        _ref = jsonData.Phases;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          phase = _ref[_i];
          rel.addPhase(new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id));
        }
        rel.phases.sort(function(a, b) {
          return a.startDate.date - b.startDate.date;
        });
        _ref2 = jsonData.Projects;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          project = _ref2[_j];
          rel.addProject(new Project(project.Id, project.Title, project.ShortName));
          this.setReleaseProjects(rel);
        }
        return this.allReleases.splice(i, 0, rel);
      }
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      console.log("clear: selectedRelease: " + (this.selectedRelease().title));
      return this.selectRelease(new Release(0, new Date(), new Date(), "", ""));
    };

    AdminReleaseViewmodel.prototype.addPhase = function(data) {
      this.selectRelease(new Release(0, new Date(), new Date(), "", "", data.id));
      return console.log("selectedRelease parentId: " + (this.selectedRelease().parentId));
    };

    AdminReleaseViewmodel.prototype.saveSelected = function() {
      var a, i, parentrel, rel,
        _this = this;
      console.log("saveSelected: selectedRelease: " + (this.selectedRelease()));
      console.log(ko.toJSON(this.selectedRelease()));
      console.log(ko.isObservable(this.selectedRelease().projects));
      rel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedRelease().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      parentrel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedRelease().parentId) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.allReleases().indexOf(rel) === -1 ? this.allReleases().indexOf(parentrel) : this.allReleases().indexOf(rel);
      return this.selectedRelease().save("/planner/Release/Save", ko.toJSON(this.selectedRelease()), function(data) {
        return _this.refreshRelease(i, data);
      });
    };

    AdminReleaseViewmodel.prototype.deleteRelease = function(data) {
      var a, i, id, parentrel, rel,
        _this = this;
      if (data.parentId === void 0) {
        rel = ((function() {
          var _i, _len, _ref, _results;
          _ref = this.allReleases();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.id) _results.push(a);
          }
          return _results;
        }).call(this))[0];
        id = data.id;
        i = this.allReleases().indexOf(rel);
      } else {
        parentrel = ((function() {
          var _i, _len, _ref, _results;
          _ref = this.allReleases();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.parentId) _results.push(a);
          }
          return _results;
        }).call(this))[0];
        rel = ((function() {
          var _i, _len, _ref, _results;
          _ref = parentrel.phases;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.id) _results.push(a);
          }
          return _results;
        })())[0];
        id = data.parentId;
        i = this.allReleases().indexOf(parentrel);
      }
      return rel["delete"]("/planner/Release/Delete/" + rel.id, function(callbackdata) {
        console.log(callbackdata);
        return rel.get("/planner/Release/GetReleaseSummaryById/" + id, function(jsonData) {
          return _this.refreshRelease(i, jsonData);
        });
      });
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
