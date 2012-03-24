(function() {
  var ReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseViewmodel = (function() {

    function ReleaseViewmodel(release) {
      var ph, phase, statusgroup, _i, _j, _len, _len2, _ref, _ref2,
        _this = this;
      this.release = release;
      this.loadProjects = __bind(this.loadProjects, this);
      this.fromNowTillEnd = new Phase(new Date(), this.release.endDate, "from now till end");
      this.projects = [];
      this.statuses = [];
      this.currentPhases = [];
      _ref = this.release.sets;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        statusgroup = _ref[_i];
        if (statusgroup.groupedBy === "state") {
          this.statuses.push(statusgroup.label);
        }
      }
      _ref2 = this.phases();
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        phase = _ref2[_j];
        if (!(phase.isCurrent())) continue;
        ph = new Phase(this.currentDate(), phase.endDate, "");
        phase.workingDaysRemaining = ph.workingDays();
        this.currentPhases.push(phase);
      }
      this.disgardedStatuses = ko.observableArray();
      this.loadProjects();
      this.displaySelected = ko.computed(function() {
        var item, s, _k, _len3, _ref3;
        console.log(_this);
        console.log(_this.disgardedStatuses());
        showTableChart();
        s = "";
        _ref3 = _this.disgardedStatuses();
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          item = _ref3[_k];
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

    ReleaseViewmodel.prototype.phases = function() {
      return this.release.phases;
    };

    ReleaseViewmodel.prototype.releaseWorkingDaysRemaining = function() {
      return this.fromNowTillEnd.workingDays();
    };

    ReleaseViewmodel.prototype.loadProjects = function() {
      var proj, set, _i, _len, _ref, _results,
        _this = this;
      _ref = this.release.sets;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        set = _ref[_i];
        if (!(set.groupedBy === "project")) continue;
        proj = set;
        proj.projectname = set.label;
        proj.link = "#" + set.label;
        proj.totalHours = (function(proj) {
          return ko.computed(function() {
            var t;
            t = 0;
            $.each(proj.items, function(n, l) {
              var _ref2;
              if (!(_ref2 = l.state, __indexOf.call(_this.disgardedStatuses(), _ref2) >= 0)) {
                return t += l.remainingHours;
              }
            });
            return t;
          });
        })(proj);
        _results.push(this.projects.push(proj));
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
      var available, balanceHours, item, member, phase, project, projectHours, projs, projset, set, uGetHours, workload, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3;
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
      balanceHours = [];
      for (_l = 0, _len4 = projs.length; _l < _len4; _l++) {
        item = projs[_l];
        project = item.project, workload = item.workload, available = item.available;
        balanceHours.push({
          projectname: project,
          availableHours: available,
          workload: workload,
          balance: Math.round(available - workload)
        });
      }
      return balanceHours;
    };

    return ReleaseViewmodel;

  })();

  root.ReleaseViewmodel = ReleaseViewmodel;

}).call(this);
