(function() {
  var ReleaseViewmodel, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseViewmodel = (function() {

    function ReleaseViewmodel(release) {
      var _this = this;
      this.release = release;
      this.fromNowTillEnd = new Phase(new Date(), this.release.endDate, "from now till end");
      this.projects = [];
      this.disgardedStatuses = ko.observableArray();
      this.disgardedStatuses.push("Under Development");
      this.loadProjects();
      this.displaySelected = ko.computed(function() {
        var item, s, _i, _len, _ref;
        console.log(_this);
        console.log(_this.disgardedStatuses());
        s = "";
        _ref = _this.disgardedStatuses();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          s += "" + item + " - ";
        }
        return s;
      }, this);
    }

    ReleaseViewmodel.prototype.releaseTitle = function() {
      return this.release.title;
    };

    ReleaseViewmodel.prototype.releaseStartdate = function() {
      return this.release.startDate;
    };

    ReleaseViewmodel.prototype.releaseEnddate = function() {
      return this.release.endDate;
    };

    ReleaseViewmodel.prototype.releaseWorkingDays = function() {
      return this.release.workingDays();
    };

    ReleaseViewmodel.prototype.currentDate = function() {
      return new Date();
    };

    ReleaseViewmodel.prototype.releaseWorkingDaysRemaining = function() {
      return this.fromNowTillEnd.workingDays();
    };

    ReleaseViewmodel.prototype.phases = function() {
      return this.release.phases;
    };

    ReleaseViewmodel.prototype.loadProjects = function() {
      var set, _i, _len, _ref, _results,
        _this = this;
      _ref = this.release.sets;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        set = _ref[_i];
        if (!(set.groupedBy === "project")) continue;
        set.projectname = set.label;
        set.link = "#" + set.label;
        set.totalHours = ko.computed(function() {
          var t;
          console.log(set.projectname);
          t = 0;
          $.each(set.items, function(n, l) {
            var _ref2;
            console.log(l.state);
            if (!(_ref2 = l.state, __indexOf.call(_this.disgardedStatuses(), _ref2) >= 0)) {
              return t += l.remainingHours;
            }
          });
          console.log(t);
          return t;
        });
        console.log("end loadProjects()");
        _results.push(this.projects.push(set));
      }
      return _results;
    };

    ReleaseViewmodel.prototype.statusData = function() {
      var data, status, statusgroup, _i, _len, _ref;
      status = [];
      _ref = this.release.sets;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        statusgroup = _ref[_i];
        if (!(statusgroup.groupedBy === "state")) continue;
        data = [];
        data.push(statusgroup.label);
        data.push(statusgroup.items.length);
        status.push(data);
      }
      return status;
    };

    ReleaseViewmodel.prototype.hourBalance = function() {
      var available, availableHours, balanceHours, item, member, phase, project, projectHours, projectNames, projs, projset, remainingHours, set, uGetHours, workload, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3;
      projs = [];
      _ref = this.release.sets;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        set = _ref[_i];
        if (!(set.groupedBy === "memberProject")) continue;
        projectHours = {};
        phase = ((function() {
          var _j, _len2, _ref2, _results;
          _ref2 = this.release.phases;
          _results = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            item = _ref2[_j];
            if (item.title === "Ontwikkelfase") _results.push(item);
          }
          return _results;
        }).call(this))[0];
        set.availableHours = 0;
        _ref2 = set.items;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          member = _ref2[_j];
          uGetHours = new UGetAvailableHoursForTeamMemberFromNow(member, phase);
          set.availableHours += uGetHours.execute();
        }
        projectHours.project = set.label;
        projectHours.available = Math.round(set.availableHours);
        _ref3 = this.projects;
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          projset = _ref3[_k];
          if (projset.projectname === set.label) {
            projectHours.workload = Math.round(projset.totalHours());
          }
        }
        projs.push(projectHours);
      }
      projectNames = [];
      remainingHours = [];
      availableHours = [];
      balanceHours = [];
      for (_l = 0, _len4 = projs.length; _l < _len4; _l++) {
        item = projs[_l];
        project = item.project, workload = item.workload, available = item.available;
        projectNames.push(project);
        remainingHours.push(workload);
        availableHours.push(available);
        balanceHours.push(Math.round(available - workload));
      }
      return {
        projectNames: projectNames,
        remainingHours: remainingHours,
        availableHours: availableHours,
        balanceHours: balanceHours
      };
    };

    return ReleaseViewmodel;

  })();

  root.ReleaseViewmodel = ReleaseViewmodel;

}).call(this);
