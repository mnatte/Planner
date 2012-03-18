(function() {
  var UDisplayReleaseStatus, UGetAvailableHoursForTeamMemberFromNow, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  UDisplayReleaseStatus = (function() {

    function UDisplayReleaseStatus() {
      Release.extend(RGroupBy);
      Resource.extend(RTeamMember);
    }

    UDisplayReleaseStatus.prototype.execute = function(data) {
      var absence, available, availableHours, balanceHours, feat, ft, item, member, phase, project, projectHours, projectMembers, projectNames, projects, projset, remainingHours, set, statusData, statusgroup, teamMember, uGetHours, workload, _i, _j, _k, _l, _len, _len10, _len11, _len2, _len3, _len4, _len5, _len6, _len7, _len8, _len9, _m, _n, _o, _p, _q, _r, _ref, _ref10, _ref11, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9, _s;
      projectMembers = [];
      this.release = new Release(DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title);
      _ref = data.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        this.release.addPhase(new Phase(DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title));
      }
      _ref2 = data.Backlog;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        feat = _ref2[_j];
        this.release.addFeature(new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project.ShortName, feat.RemainingHours, feat.Title, feat.Status));
        _ref3 = feat.Project.ProjectTeam.TeamMembers;
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          member = _ref3[_k];
          if (!(_ref4 = "" + member.Initials + "_" + feat.Project.ShortName, __indexOf.call(projectMembers, _ref4) < 0)) {
            continue;
          }
          teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Function);
          teamMember.focusFactor = member.FocusFactor;
          teamMember.memberProject = feat.Project.ShortName;
          _ref5 = member.PeriodsAway;
          for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
            absence = _ref5[_l];
            if (DateFormatter.createJsDateFromJson(absence.EndDate) < this.release.endDate || DateFormatter.createJsDateFromJson(absence.StartDate) >= this.release.startDate) {
              teamMember.addAbsence(new Phase(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title));
            }
          }
          this.release.addResource(teamMember);
          projectMembers.push("" + member.Initials + "_" + feat.Project.ShortName);
        }
      }
      this.release.group('project', this.release.backlog);
      this.release.group('state', this.release.backlog);
      this.release.group('memberProject', this.release.resources);
      statusData = [];
      _ref6 = this.release.sets;
      for (_m = 0, _len5 = _ref6.length; _m < _len5; _m++) {
        statusgroup = _ref6[_m];
        if (!(statusgroup.groupedBy === "state")) continue;
        data = [];
        data.push(statusgroup.label);
        data.push(statusgroup.items.length);
        statusData.push(data);
      }
      _ref7 = this.release.sets;
      for (_n = 0, _len6 = _ref7.length; _n < _len6; _n++) {
        set = _ref7[_n];
        if (!(set.groupedBy === "project")) continue;
        set.link = "#" + set.label;
        set.totalHours = 0;
        _ref8 = set.items;
        for (_o = 0, _len7 = _ref8.length; _o < _len7; _o++) {
          ft = _ref8[_o];
          if (!(ft.state === "Descoped" || ft.state === "Ready for UAT" || ft.state === "Under UAT")) {
            set.totalHours += ft.remainingHours;
          }
        }
      }
      projects = [];
      _ref9 = this.release.sets;
      for (_p = 0, _len8 = _ref9.length; _p < _len8; _p++) {
        set = _ref9[_p];
        if (!(set.groupedBy === "memberProject")) continue;
        projectHours = {};
        console.log("memberProject: " + set.label + " " + set.items.length + " members");
        phase = ((function() {
          var _len9, _q, _ref10, _results;
          _ref10 = this.release.phases;
          _results = [];
          for (_q = 0, _len9 = _ref10.length; _q < _len9; _q++) {
            item = _ref10[_q];
            if (item.title === "Ontwikkelfase") _results.push(item);
          }
          return _results;
        }).call(this))[0];
        set.availableHours = 0;
        _ref10 = set.items;
        for (_q = 0, _len9 = _ref10.length; _q < _len9; _q++) {
          member = _ref10[_q];
          uGetHours = new UGetAvailableHoursForTeamMemberFromNow(member, phase);
          set.availableHours += uGetHours.execute();
        }
        projectHours.project = set.label;
        projectHours.available = Math.round(set.availableHours);
        _ref11 = this.release.sets;
        for (_r = 0, _len10 = _ref11.length; _r < _len10; _r++) {
          projset = _ref11[_r];
          if (projset.groupedBy === "project" && projset.label === set.label) {
            projectHours.workload = Math.round(projset.totalHours);
          }
        }
        projects.push(projectHours);
      }
      console.log(projects);
      projectNames = [];
      remainingHours = [];
      availableHours = [];
      balanceHours = [];
      for (_s = 0, _len11 = projects.length; _s < _len11; _s++) {
        item = projects[_s];
        project = item.project, workload = item.workload, available = item.available;
        projectNames.push(project);
        remainingHours.push(workload);
        availableHours.push(available);
        balanceHours.push(Math.round(available - workload));
      }
      ko.applyBindings(this.release);
      showStatusChart(statusData);
      return showHoursChart(projectNames, remainingHours, availableHours, balanceHours);
    };

    return UDisplayReleaseStatus;

  })();

  UGetAvailableHoursForTeamMemberFromNow = (function() {

    function UGetAvailableHoursForTeamMemberFromNow(teamMember, phase) {
      this.teamMember = teamMember;
      this.phase = phase;
    }

    UGetAvailableHoursForTeamMemberFromNow.prototype.execute = function() {
      var absence, absentHours, availableHours, endDate, periodAway, restPeriod, startDate, today, _i, _len, _ref;
      console.log("available hours for: " + this.teamMember.initials);
      console.log("in phase: " + (this.phase.toString()));
      today = new Date();
      restPeriod = new Phase(today, this.phase.endDate, this.phase.title);
      console.log("period: " + restPeriod);
      absentHours = 0;
      _ref = this.teamMember.periodsAway;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        absence = _ref[_i];
        if (absence.endDate < restPeriod.endDate) {
          endDate = absence.endDate;
        } else {
          endDate = restPeriod.endDate;
        }
        if (absence.startDate > today) {
          startDate = absence.startDate;
        } else {
          startDate = today;
        }
        periodAway = new Phase(startDate, endDate, "Absence in phase");
        console.log("periodAway: " + (periodAway.toString()));
        absentHours += periodAway.workingHours();
      }
      console.log("absentHours: " + absentHours);
      availableHours = restPeriod.workingHours() - absentHours;
      console.log("availableHours: " + availableHours);
      console.log("corrected with focusfactor " + this.teamMember.focusFactor + ": " + (this.teamMember.focusFactor * availableHours));
      return this.teamMember.focusFactor * availableHours;
    };

    return UGetAvailableHoursForTeamMemberFromNow;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

  root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow;

}).call(this);
