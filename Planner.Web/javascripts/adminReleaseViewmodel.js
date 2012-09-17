(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases, allProjects, allDeliverables) {
      this.deleteRelease = __bind(this.deleteRelease, this);
      this.saveSelectedMilestone = __bind(this.saveSelectedMilestone, this);
      this.saveSelectedPhase = __bind(this.saveSelectedPhase, this);
      this.saveSelected = __bind(this.saveSelected, this);
      this.unAssignMilestone = __bind(this.unAssignMilestone, this);
      this.addNewMilestone = __bind(this.addNewMilestone, this);
      this.addPhase = __bind(this.addPhase, this);
      this.refreshRelease = __bind(this.refreshRelease, this);
      this.selectMilestone = __bind(this.selectMilestone, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectRelease = __bind(this.selectRelease, this);
      var rel, _fn, _i, _len, _ref;
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
      Phase.extend(RCrud);
      Milestone.extend(RCrud);
      this.selectedRelease = ko.observable();
      this.selectedPhase = ko.observable();
      this.selectedMilestone = ko.observable();
      this.formType = ko.observable("release");
      this.allReleases = ko.observableArray(allReleases);
      this.allProjects = ko.observableArray(allProjects);
      this.allDeliverables = ko.observableArray(allDeliverables);
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

    AdminReleaseViewmodel.prototype.setMilestoneDeliverables = function(ms) {
      var del, m, msDels, _i, _j, _len, _len2, _ref;
      console.log("setMilestoneDeliverables");
      msDels = ms.deliverables.slice();
      console.log(msDels);
      ms.deliverables = ko.observableArray([]);
      for (_i = 0, _len = msDels.length; _i < _len; _i++) {
        del = msDels[_i];
        _ref = this.allDeliverables();
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          m = _ref[_j];
          if (!(m.id === del.id)) continue;
          console.log("assign deliverable " + m.title);
          ms.deliverables.push(m);
        }
      }
      return console.log(ms);
    };

    AdminReleaseViewmodel.prototype.selectRelease = function(data) {
      console.log("selectRelease - function");
      this.formType("release");
      this.selectedRelease(data);
      return console.log(this.selectedRelease().projects());
    };

    AdminReleaseViewmodel.prototype.selectPhase = function(data) {
      this.formType("phase");
      return this.selectedPhase(data);
    };

    AdminReleaseViewmodel.prototype.selectMilestone = function(data) {
      this.formType("milestone");
      this.selectedMilestone(data);
      return console.log(this.selectedMilestone());
    };

    AdminReleaseViewmodel.prototype.refreshRelease = function(index, jsonData) {
      var i, milestone, ms, phase, project, rel, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      i = index >= 0 ? index : this.allReleases().length;
      console.log("index: " + index);
      console.log("i: " + i);
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
        _ref2 = jsonData.Milestones;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          milestone = _ref2[_j];
          ms = Milestone.create(milestone, rel.id);
          this.setMilestoneDeliverables(ms);
          rel.addMilestone(ms);
        }
        rel.phases.sort(function(a, b) {
          return a.startDate.date - b.startDate.date;
        });
        rel.milestones.sort(function(a, b) {
          return a.date.date - b.date.date;
        });
        _ref3 = jsonData.Projects;
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          project = _ref3[_k];
          rel.addProject(new Project(project.Id, project.Title, project.ShortName));
          this.setReleaseProjects(rel);
        }
        return this.allReleases.splice(i, 0, rel);
      }
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      this.formType("release");
      return this.selectRelease(new Release(0, new Date(), new Date(), "", ""));
    };

    AdminReleaseViewmodel.prototype.addPhase = function(data) {
      this.formType("phase");
      this.selectPhase(new Release(0, new Date(), new Date(), "", "", data.id));
      return console.log("selectedRelease parentId: " + (this.selectedRelease().parentId));
    };

    AdminReleaseViewmodel.prototype.addNewMilestone = function(release) {
      this.formType("milestone");
      return this.selectedMilestone(new Milestone(0, new Date(), "0:00", "", "", release.id));
    };

    AdminReleaseViewmodel.prototype.unAssignMilestone = function(milestone) {
      var a, i, parentrel,
        _this = this;
      this.selectedMilestone(milestone);
      console.log(milestone);
      console.log(this.selectedMilestone());
      parentrel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedMilestone().phaseId) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.allReleases().indexOf(parentrel);
      return this.selectedMilestone().save("/planner/Release/UnAssignMilestone", ko.toJSON(this.selectedMilestone()), function(data) {
        return _this.refreshRelease(i, data);
      });
    };

    AdminReleaseViewmodel.prototype.saveSelected = function() {
      var a, i, parentrel, rel,
        _this = this;
      console.log("saveSelected: selectedRelease: " + (this.selectedRelease()));
      console.log(ko.toJSON(this.selectedRelease()));
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

    AdminReleaseViewmodel.prototype.saveSelectedPhase = function() {
      var a, i, parentrel,
        _this = this;
      console.log("saveSelectedPhase: selectedRelease: " + (this.selectedRelease()));
      console.log("saveSelectedPhase: selectedPhase: " + (this.selectedPhase()));
      console.log(ko.toJSON(this.selectedPhase()));
      console.log(ko.toJSON(this.selectedPhase().parentId));
      parentrel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedPhase().parentId) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.allReleases().indexOf(parentrel);
      return this.selectedPhase().save("/planner/Release/Save", ko.toJSON(this.selectedPhase()), function(data) {
        return _this.refreshRelease(i, data);
      });
    };

    AdminReleaseViewmodel.prototype.saveSelectedMilestone = function() {
      var a, i, parentrel,
        _this = this;
      console.log("saveSelectedMilestone: selectedRelease: " + (this.selectedRelease()));
      console.log("saveSelectedMilestone: selectedMilestone: " + (this.selectedMilestone()));
      console.log(ko.toJSON(this.selectedMilestone()));
      console.log(ko.toJSON(this.selectedMilestone().phaseId));
      parentrel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedMilestone().phaseId) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.allReleases().indexOf(parentrel);
      return this.selectedMilestone().save("/planner/Release/SaveMilestone", ko.toJSON(this.selectedMilestone()), function(data) {
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
