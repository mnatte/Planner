(function() {
  var UDisplayPhases, UDisplayReleaseStatus, UGetAvailableHoursForTeamMemberFromNow, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  UDisplayReleaseStatus = (function() {

    function UDisplayReleaseStatus() {
      Release.extend(RGroupBy);
      Resource.extend(RTeamMember);
    }

    UDisplayReleaseStatus.prototype.execute = function(data) {
      var absence, feat, member, phase, projectMembers, teamMember, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3, _ref4, _ref5;
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
      this.viewModel = new ReleaseViewmodel(this.release);
      ko.applyBindings(this.viewModel);
      showStatusChart(this.viewModel.statusData());
      return showTableChart();
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
      today = new Date();
      restPeriod = new Phase(today, this.phase.endDate, this.phase.title);
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
        absentHours += periodAway.workingHours();
      }
      availableHours = restPeriod.workingHours() - absentHours;
      return this.teamMember.focusFactor * availableHours;
    };

    return UGetAvailableHoursForTeamMemberFromNow;

  })();

  UDisplayPhases = (function() {

    function UDisplayPhases() {}

    UDisplayPhases.prototype.execute = function(data) {
      this.viewModel = new PhasesViewmodel();
      this.viewModel.load(data);
      return ko.applyBindings(this.viewModel);
    };

    return UDisplayPhases;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

  root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow;

  root.UDisplayPhases = UDisplayPhases;

}).call(this);
