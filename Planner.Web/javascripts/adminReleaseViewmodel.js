(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases, allProjects, allDeliverables) {
      this.deleteRelease = __bind(this.deleteRelease, this);
      this.setItemToDelete = __bind(this.setItemToDelete, this);
      this.confirmDelete = __bind(this.confirmDelete, this);
      this.saveSelectedMeeting = __bind(this.saveSelectedMeeting, this);
      this.saveSelectedMilestone = __bind(this.saveSelectedMilestone, this);
      this.saveSelectedPhase = __bind(this.saveSelectedPhase, this);
      this.saveSelected = __bind(this.saveSelected, this);
      this.unAssignMilestone = __bind(this.unAssignMilestone, this);
      this.addNewMilestone = __bind(this.addNewMilestone, this);
      this.removeMeeting = __bind(this.removeMeeting, this);
      this.addMeeting = __bind(this.addMeeting, this);
      this.removePhase = __bind(this.removePhase, this);
      this.addPhase = __bind(this.addPhase, this);
      this.refreshRelease = __bind(this.refreshRelease, this);
      this.selectMeeting = __bind(this.selectMeeting, this);
      this.selectMilestone = __bind(this.selectMilestone, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectRelease = __bind(this.selectRelease, this);
      this.setMeetings = __bind(this.setMeetings, this);
      this.setMilestones = __bind(this.setMilestones, this);
      this.setPhases = __bind(this.setPhases, this);
      var rel, _i, _len, _ref;
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
      Phase.extend(RCrud);
      Milestone.extend(RCrud);
      Milestone.extend(RMilestoneSerialize);
      Release.extend(RReleaseSerialize);
      Project.extend(RProjectSerialize);
      Period.extend(RPeriodSerialize);
      Phase.extend(RPhaseSerialize);
      this.selectedRelease = ko.observable();
      this.selectedPhase = ko.observable();
      this.selectedMilestone = ko.observable();
      this.selectedMeeting = ko.observable();
      this.formType = ko.observable("release");
      this.allReleases = ko.observableArray(allReleases);
      this.allProjects = ko.observableArray(allProjects);
      this.allDeliverables = ko.observableArray(allDeliverables);
      this.itemToDelete = ko.observable();
      _ref = this.allReleases();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rel = _ref[_i];
        this.setObservables(rel);
      }
      this.allReleases.sort(function(a, b) {
        return a.startDate.date - b.startDate.date;
      });
    }

    AdminReleaseViewmodel.prototype.setObservables = function(rel) {
      var ms, _i, _len, _ref;
      this.setReleaseProjects(rel);
      (function(rel) {
        return rel.phases.sort(function(a, b) {
          return a.startDate.date - b.startDate.date;
        });
      })(rel);
      this.setMilestones(rel);
      _ref = rel.milestones();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ms = _ref[_i];
        this.setMilestoneDeliverables(ms);
      }
      this.setPhases(rel);
      return this.setMeetings(rel);
    };

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
      var del, m, msDels, _i, _len, _results;
      msDels = ms.deliverables.slice();
      ms.deliverables = ko.observableArray([]);
      _results = [];
      for (_i = 0, _len = msDels.length; _i < _len; _i++) {
        del = msDels[_i];
        _results.push((function() {
          var _j, _len2, _ref, _results2;
          _ref = this.allDeliverables();
          _results2 = [];
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            m = _ref[_j];
            if (m.id === del.id) _results2.push(ms.deliverables.push(m));
          }
          return _results2;
        }).call(this));
      }
      return _results;
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

    AdminReleaseViewmodel.prototype.setMeetings = function(rel) {
      var meetings;
      meetings = rel.meetings.slice();
      return rel.meetings = ko.observableArray(meetings);
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

    AdminReleaseViewmodel.prototype.selectMeeting = function(data) {
      this.formType("meeting");
      this.selectedMeeting(data);
      return console.log(this.selectedMeeting());
    };

    AdminReleaseViewmodel.prototype.refreshRelease = function(index, jsonData) {
      var i, rel;
      i = index >= 0 ? index : this.allReleases().length;
      if (jsonData !== null && jsonData !== void 0) {
        rel = Release.create(jsonData);
        this.setObservables(rel);
        rel.phases.sort(function(a, b) {
          return a.startDate.date - b.startDate.date;
        });
        rel.milestones.sort(function(a, b) {
          return a.date.date - b.date.date;
        });
        rel.meetings.sort(function(a, b) {
          return a.date.date - b.date.date;
        });
        this.allReleases.splice(i, 1, rel);
        return this.selectRelease(rel);
      }
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      var release;
      this.formType("release");
      release = new Release(0, new Date(), new Date(), "", "");
      this.setObservables(release);
      return this.selectRelease(release);
    };

    AdminReleaseViewmodel.prototype.addPhase = function(data) {
      var allPhases, allPhasesArr, maxId, newId;
      this.formType("phase");
      allPhasesArr = this.allReleases().reduce(function(acc, x) {
        acc.push([x]);
        acc.push(x.phases());
        return acc;
      }, []);
      allPhases = allPhasesArr.reduce(function(acc, x) {
        var result;
        result = acc.concat(x);
        return result;
      }, []);
      maxId = allPhases.reduce(function(acc, x) {
        var max;
        max = acc > x.id ? acc : x.id;
        return max;
      }, 0);
      newId = maxId + 1;
      this.selectPhase(new Phase(newId, new Date(), new Date(), "", "", this.selectedRelease().id));
      return console.log("selectedPhase: " + (ko.toJSON(this.selectedPhase())));
    };

    AdminReleaseViewmodel.prototype.removePhase = function(data) {
      var a, i, phase;
      phase = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedRelease().phases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === data.id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.selectedRelease().phases().indexOf(phase);
      return this.selectedRelease().phases.splice(i, 1);
    };

    AdminReleaseViewmodel.prototype.addMeeting = function(data) {
      var allMeetings, allMeetingsArr, maxId, newId;
      this.formType("meeting");
      allMeetingsArr = this.allReleases().reduce(function(acc, x) {
        acc.push([x]);
        acc.push(x.meetings());
        return acc;
      }, []);
      allMeetings = allMeetingsArr.reduce(function(acc, x) {
        var result;
        result = acc.concat(x);
        return result;
      }, []);
      maxId = allMeetings.reduce(function(acc, x) {
        var max;
        max = acc > x.id ? acc : x.id;
        return max;
      }, 0);
      newId = maxId + 1;
      this.selectMeeting(new Meeting(newId, "", "", "", "", new Date(), "09:00", this.selectedRelease().id));
      return console.log("selectedMeeting: " + (ko.toJSON(this.selectedMeeting())));
    };

    AdminReleaseViewmodel.prototype.removeMeeting = function(data) {
      var a, i, meeting;
      meeting = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedRelease().meetings();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === data.id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.selectedRelease().meetings().indexOf(meeting);
      return this.selectedRelease().meetings.splice(i, 1);
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
      var a, i, ms;
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
      return this.selectedRelease().milestones.splice(i, 1);
    };

    AdminReleaseViewmodel.prototype.saveSelected = function() {
      var a, i, rel,
        _this = this;
      console.log("saveSelected");
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
      i = this.allReleases().indexOf(rel);
      return this.selectedRelease().save("/planner/Release/SaveReleaseConfiguration", this.selectedRelease().toConfigurationSnapshotJson(), function(data) {
        return _this.refreshRelease(i, data);
      });
    };

    AdminReleaseViewmodel.prototype.saveSelectedPhase = function() {
      var a, phase;
      phase = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedRelease().phases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedPhase().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      if (typeof phase === "undefined" || phase === null || phase.id === 0) {
        return this.selectedRelease().addPhase(this.selectedPhase());
      }
    };

    AdminReleaseViewmodel.prototype.saveSelectedMilestone = function() {
      var a, ms;
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
      if (typeof ms === "undefined" || ms === null || ms.id === 0) {
        return this.selectedRelease().addMilestone(this.selectedMilestone());
      }
    };

    AdminReleaseViewmodel.prototype.saveSelectedMeeting = function() {
      var a, m;
      m = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedRelease().meetings();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedMeeting().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      if (typeof m === "undefined" || m === null || m.id === 0) {
        return this.selectedRelease().addMeeting(this.selectedMeeting());
      }
    };

    AdminReleaseViewmodel.prototype.confirmDelete = function() {
      return this.deleteRelease(this.itemToDelete(), $.unblockUI());
    };

    AdminReleaseViewmodel.prototype.setItemToDelete = function(item) {
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

    AdminReleaseViewmodel.prototype.deleteRelease = function(data) {
      var a, i, id, rel,
        _this = this;
      console.log('deleteRelease');
      console.log(data);
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
      return rel["delete"]("/planner/Release/Delete/" + rel.id, function(callbackdata) {
        var next;
        _this.allReleases.splice(i, 1);
        next = _this.allReleases()[i];
        console.log(next);
        _this.selectRelease(next);
        return $.unblockUI();
      });
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
