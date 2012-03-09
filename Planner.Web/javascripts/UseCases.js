(function() {
  var UDisplayReleaseStatus, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  UDisplayReleaseStatus = (function() {

    function UDisplayReleaseStatus() {
      Release.extend(RGroupBy);
      Resource.extend(RTeamMember);
    }

    UDisplayReleaseStatus.prototype.execute = function(data) {
      var feat, ft, member, phase, projectMembers, set, statusData, statusgroup, teamMember, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _len6, _len7, _len8, _m, _n, _o, _p, _ref, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      projectMembers = [];
      this.release = new Release(DateFormatter.formatJsonDate(data.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(data.EndDate, "dd/MM/yyyy"), data.WorkingDays, data.Title);
      _ref = data.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        this.release.addPhase(new Phase(DateFormatter.formatJsonDate(phase.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(phase.EndDate, "dd/MM/yyyy"), phase.WorkingDays, phase.Title));
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
          console.log("ADD TEAMMEMBERS TO PROJECT");
          teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Function);
          teamMember.focusFactor = member.FocusFactor;
          teamMember.memberProject = feat.Project.ShortName;
          this.release.addResource(teamMember);
          projectMembers.push("" + member.Initials + "_" + feat.Project.ShortName);
          console.log(projectMembers);
        }
      }
      this.release.group('project', this.release.backlog);
      this.release.group('state', this.release.backlog);
      this.release.group('memberProject', this.release.resources);
      _ref5 = this.release.sets;
      for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
        set = _ref5[_l];
        if (!(set.groupedBy === "project")) continue;
        set.link = "#" + set.label;
        set.totalHours = 0;
        _ref6 = set.items;
        for (_m = 0, _len5 = _ref6.length; _m < _len5; _m++) {
          ft = _ref6[_m];
          if (ft.state !== "Descoped") set.totalHours += ft.remainingHours;
        }
      }
      statusData = [];
      _ref7 = this.release.sets;
      for (_n = 0, _len6 = _ref7.length; _n < _len6; _n++) {
        statusgroup = _ref7[_n];
        if (!(statusgroup.groupedBy === "state")) continue;
        data = [];
        data.push(statusgroup.label);
        data.push(statusgroup.items.length);
        statusData.push(data);
      }
      _ref8 = this.release.sets;
      for (_o = 0, _len7 = _ref8.length; _o < _len7; _o++) {
        set = _ref8[_o];
        if (!(set.groupedBy === "memberProject")) continue;
        console.log("memberProject: " + set.label + " " + set.items.length + " members");
        set.availableHours = 0;
        _ref9 = set.items;
        for (_p = 0, _len8 = _ref9.length; _p < _len8; _p++) {
          member = _ref9[_p];
          console.log("" + member.initials + " hours per week: " + member.hoursPerWeek);
          set.availableHours += member.hoursPerWeek * member.focusFactor;
        }
        console.log("available hours for " + set.label + ": " + set.availableHours);
      }
      ko.applyBindings(this.release);
      return showStatusChart(statusData);
    };

    return UDisplayReleaseStatus;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

}).call(this);
