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
      this.setMilestones = __bind(this.setMilestones, this);
      this.setPhases = __bind(this.setPhases, this);
      var ms, rel, _fn, _i, _j, _len, _len2, _ref, _ref2;
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
        this.setMilestones(rel);
        _ref2 = rel.milestones();
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          ms = _ref2[_j];
          this.setMilestoneDeliverables(ms);
        }
        this.setPhases(rel);
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
      console.log("setMilestoneDeliverables to observableArray");
      msDels = ms.deliverables.slice();
      console.log(msDels);
      ms.deliverables = ko.observableArray([]);
      for (_i = 0, _len = msDels.length; _i < _len; _i++) {
        del = msDels[_i];
        _ref = this.allDeliverables();
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          m = _ref[_j];
          if (m.id === del.id) ms.deliverables.push(m);
        }
      }
      return console.log(ms);
    };

    AdminReleaseViewmodel.prototype.setPhases = function(rel) {
      var phases;
      phases = rel.phases.slice();
      return rel.phases = ko.observableArray(phases);
    };

    AdminReleaseViewmodel.prototype.setMilestones = function(rel) {
      var milestones;
      milestones = rel.milestones.slice();
      return rel.milestones = ko.observableArray(milestones);
    };

    AdminReleaseViewmodel.prototype.selectRelease = function(data) {
      this.formType("release");
      return this.selectedRelease(data);
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
      var i, ms, rel, _i, _len, _ref;
      i = index >= 0 ? index : this.allReleases().length;
      console.log("index: " + index);
      console.log("i: " + i);
      console.log(jsonData);
      if (jsonData !== null && jsonData !== void 0) {
        console.log("jsonData not undefined");
        rel = Release.create(jsonData);
        this.setReleaseProjects(rel);
        _ref = rel.milestones;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ms = _ref[_i];
          this.setMilestoneDeliverables(ms);
        }
        this.setPhases(rel);
        rel.phases.sort(function(a, b) {
          return a.startDate.date - b.startDate.date;
        });
        rel.milestones.sort(function(a, b) {
          return a.date.date - b.date.date;
        });
        return this.allReleases.splice(i, 1, rel);
      }
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      var release;
      this.formType("release");
      release = new Release(0, new Date(), new Date(), "", "");
      this.setReleaseProjects(release);
      return this.selectRelease(release);
    };

    AdminReleaseViewmodel.prototype.addPhase = function(data) {
      var maxId;
      this.formType("phase");
      maxId = this.allReleases().reduce(function(acc, x) {
        var max;
        max = acc > x.id ? acc : x.id;
        return max;
      }, 0);
      this.selectPhase(new Release(0, new Date(), new Date(), "", "", this.selectedRelease().id));
      console.log("selectedPhase: " + (ko.toJSON(this.selectedPhase())));
      return console.log("selectedRelease id: " + (this.selectedRelease().id));
    };

    AdminReleaseViewmodel.prototype.addNewMilestone = function(release) {
      var allMilestones, allMilestonesArr, maxId, newId, newMs;
      this.formType("milestone");
      allMilestonesArr = this.allReleases().reduce(function(acc, x) {
        acc.push(x.milestones());
        return acc;
      }, []);
      allMilestones = allMilestonesArr.reduce(function(acc, x) {
        var result;
        result = acc.concat(x);
        return result;
      }, []);
      maxId = allMilestones.reduce(function(acc, x) {
        var max;
        max = acc > x.id ? acc : x.id;
        return max;
      }, 0);
      newId = maxId + 1;
      newMs = new Milestone(newId, new Date(), "0:00", "New Milestone", "", this.selectedRelease().id);
      this.setMilestoneDeliverables(newMs);
      this.selectedMilestone(newMs);
      return console.log(this.selectedMilestone());
    };

    AdminReleaseViewmodel.prototype.unAssignMilestone = function(milestone) {
      var a, assignment, i, ms;
      console.log(milestone);
      ms = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedRelease().milestones();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === milestone.id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.selectedRelease().milestones().indexOf(ms);
      assignment = this.selectedMilestone();
      assignment.phaseId = this.selectedRelease().id;
      return this.selectedRelease().milestones.splice(i, 1);
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
        return _this.selectedRelease().phases.push(_this.selectedPhase());
      });
    };

    AdminReleaseViewmodel.prototype.saveSelectedMilestone = function() {
      var a, dels, ms;
      console.log(ko.toJSON(this.selectedMilestone()));
      ms = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedRelease().milestones();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedMilestone().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      dels = ko.toJSON(this.selectedMilestone().deliverables());
      console.log(dels);
      if (typeof ms === "undefined" || ms === null || ms.id === 0) {
        return this.selectedRelease().addMilestone(this.selectedMilestone());
      }
    };

    AdminReleaseViewmodel.prototype.deleteRelease = function(data) {
      var a, i, id, isRelease, parentrel, rel,
        _this = this;
      console.log('deleteRelease');
      console.log(data);
      isRelease = data.parentId === void 0;
      if (isRelease) {
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
        console.log(parentrel);
        rel = ((function() {
          var _i, _len, _ref, _results;
          _ref = parentrel.phases();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.id) _results.push(a);
          }
          return _results;
        })())[0];
        console.log(rel);
        id = data.parentId;
      }
      return rel["delete"]("/planner/Release/Delete/" + rel.id, function(callbackdata) {
        var a, next, phase;
        if (isRelease) {
          _this.allReleases.splice(i, 1);
          next = _this.allReleases()[i];
          console.log(next);
          return _this.selectRelease(next);
        } else {
          phase = ((function() {
            var _i, _len, _ref, _results;
            _ref = this.selectedRelease().phases;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              a = _ref[_i];
              if (a.id === data.id) _results.push(a);
            }
            return _results;
          }).call(_this))[0];
          i = _this.selectedRelease().phases.indexOf(phase);
          return _this.selectedRelease().phases.splice(i, 1);
        }
      });
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
