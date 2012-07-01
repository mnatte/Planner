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
      this.hourBalance = __bind(this.hourBalance, this);
      this.loadProjects = __bind(this.loadProjects, this);
      this.fromNowTillEnd = new Period(new Date(), this.release.endDate.date, "from now till end");
      this.projects = [];
      this.statuses = [];
      this.currentPhases = [];
      this.hoursChartOptions = {
        chart: {
          renderTo: 'chart-hours',
          type: 'column'
        },
        title: {
          text: 'Workload overview'
        },
        xAxis: {
          categories: ['Pief', 'Paf', 'Poef']
        },
        yAxis: {
          title: {
            text: 'Hours'
          }
        },
        tooltip: {
          formatter: function() {
            return '<b>' + this.series.name + '</b><br/>' + this.y + ' ' + this.x.toLowerCase();
          }
        }
      };
      this.hoursChart = new Highcharts.Chart(this.hoursChartOptions);
      this.categories = ko.observableArray(['aap', 'noot', 'mies']);
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
        ph = new Period(this.currentDate(), phase.endDate.date, "");
        phase.workingDaysRemaining = ph.workingDays();
        this.currentPhases.push(phase);
      }
      this.selectedPhaseId = ko.observable();
      this.selectedPhaseId.subscribe(function(newValue) {
        var available, balance, hours, proj, projHours, projects, work, _k, _len3;
        projHours = _this.hourBalance(newValue);
        console.log("from subscription: " + ko.toJSON(projHours));
        projects = [];
        available = [];
        work = [];
        balance = [];
        hours = [];
        for (_k = 0, _len3 = projHours.length; _k < _len3; _k++) {
          proj = projHours[_k];
          projects.push(proj.projectname);
          available.push(proj.availableHours);
          work.push(proj.workload);
          balance.push(proj.balance);
        }
        hours.push({
          name: 'Available Hrs',
          data: available
        });
        hours.push({
          name: 'Work Remaining',
          data: work
        });
        hours.push({
          name: 'Balance',
          data: balance
        });
        console.log(projects);
        console.log(ko.toJSON(hours));
        _this.hoursChartOptions.xAxis.categories = projects;
        _this.hoursChartOptions.series = hours;
        _this.hoursChart.destroy;
        return _this.hoursChart = new Highcharts.Chart(_this.hoursChartOptions);
      });
      this.disgardedStatuses = ko.observableArray();
      this.disgardedStatuses.subscribe(function(newValue) {});
      this.loadProjects();
    }

    ReleaseViewmodel.prototype.releaseTitle = function() {
      return this.release.title;
    };

    ReleaseViewmodel.prototype.releaseStartdate = function() {
      return this.release.startDate.date;
    };

    ReleaseViewmodel.prototype.releaseEnddate = function() {
      return this.release.endDate.date;
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

    ReleaseViewmodel.prototype.hourBalance = function(selectedPhaseId) {
      var available, balanceHours, feat, item, phase, phaseId, proj, projs, releasePhases, remainingHours, res, _i, _len, _ref;
      phaseId = selectedPhaseId;
      releasePhases = this.release.phases;
      projs = [];
      balanceHours = [];
      phase = ((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = releasePhases.length; _i < _len; _i++) {
          item = releasePhases[_i];
          if (+item.id === +phaseId) _results.push(item);
        }
        return _results;
      })())[0];
      _ref = this.release.projects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        proj = _ref[_i];
        console.log(proj);
        remainingHours = ((function() {
          var _j, _len2, _ref2, _results;
          _ref2 = proj.backlog;
          _results = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            feat = _ref2[_j];
            _results.push(feat.remainingHours);
          }
          return _results;
        })()).reduce(function(acc, x) {
          return acc + x;
        });
        console.log("remainingHours: " + remainingHours);
        available = 0;
        console.log(proj.resources);
        if (proj.resources.length > 0) {
          console.log("proj.resources not empty");
          available = ((function() {
            var _j, _len2, _ref2, _results;
            _ref2 = proj.resources;
            _results = [];
            for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
              res = _ref2[_j];
              _results.push(res.availableHours());
            }
            return _results;
          })()).reduce(function(acc, x) {
            console.log(x);
            return acc + x;
          });
        }
        console.log("available: " + available);
        balanceHours.push({
          projectname: proj.shortName,
          availableHours: available,
          workload: remainingHours,
          balance: Math.round(available - remainingHours)
        });
      }
      console.log("balanceHours: " + ko.toJSON(balanceHours));
      return balanceHours;
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

    return ReleaseViewmodel;

  })();

  root.ReleaseViewmodel = ReleaseViewmodel;

}).call(this);
