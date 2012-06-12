(function() {
  var HLoadReleases, UDisplayPhases, UDisplayReleaseStatus, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, ULoadPlanResources, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  HLoadReleases = (function() {

    function HLoadReleases() {}

    HLoadReleases.prototype.execute = function(data) {
      var phase, project, release, releases, _i, _j, _k, _len, _len2, _len3, _ref, _ref2;
      releases = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        release = data[_i];
        this.release = new Release(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title, release.TfsIterationPath);
        _ref = release.Phases;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          phase = _ref[_j];
          this.release.addPhase(new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, release.Id));
        }
        _ref2 = release.Projects;
        for (_k = 0, _len3 = _ref2.length; _k < _len3; _k++) {
          project = _ref2[_k];
          this.release.addProject(new Project(project.Id, project.Title, project.ShortName));
        }
        releases.push(this.release);
      }
      return releases;
    };

    return HLoadReleases;

  })();

  UDisplayReleaseStatus = (function() {

    function UDisplayReleaseStatus() {
      Release.extend(RGroupBy);
      Resource.extend(RTeamMember);
    }

    UDisplayReleaseStatus.prototype.execute = function(data) {
      var absence, feat, member, phase, projectMembers, teamMember, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3, _ref4, _ref5;
      projectMembers = [];
      this.release = new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath);
      document.title = data.Title;
      _ref = data.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        this.release.addPhase(new Phase(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath));
      }
      console.log(this.release);
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
          teamMember = Resource.create(member);
          teamMember.focusFactor = member.FocusFactor;
          teamMember.memberProject = feat.Project.ShortName;
          _ref5 = member.PeriodsAway;
          for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
            absence = _ref5[_l];
            if (DateFormatter.createJsDateFromJson(absence.EndDate) < this.release.endDate.date || DateFormatter.createJsDateFromJson(absence.StartDate) >= this.release.startDate.date) {
              teamMember.addAbsence(new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title));
            }
          }
          this.release.addResource(teamMember);
          console.log(teamMember);
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
      if (today > this.phase.endDate.date) {
        return 0;
      } else {
        console.log(this.teamMember);
        console.log("available hours for: " + this.teamMember.initials);
        console.log("in phase: " + (this.phase.toString()));
        restPeriod = new Period(today, this.phase.endDate.date, this.phase.title);
        console.log("period: " + restPeriod);
        console.log("periods away: " + this.teamMember.periodsAway);
        absentHours = 0;
        _ref = this.teamMember.periodsAway;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          absence = _ref[_i];
          if (!((today <= absence.endDate.date) && (today >= absence.startDate.date))) {
            continue;
          }
          console.log("today: " + today);
          console.log("absence startDate: " + absence.startDate.date);
          console.log("absence endDate: " + absence.endDate.date);
          console.log("endDate phase restperiod: " + restPeriod.endDate.date);
          if (absence.endDate.date < restPeriod.endDate.date) {
            endDate = absence.endDate.date;
          } else {
            endDate = restPeriod.endDate.date;
          }
          if (absence.startDate.date > today) {
            startDate = absence.startDate.date;
          } else {
            startDate = today;
          }
          periodAway = new Period(startDate, endDate, "Absence in phase");
          console.log("periodAway: " + (periodAway.toString()));
          absentHours += periodAway.workingHours();
        }
        console.log("absentHours: " + absentHours);
        availableHours = restPeriod.workingHours() - absentHours;
        console.log("availableHours: " + availableHours);
        return this.teamMember.focusFactor * availableHours;
      }
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

  ULoadAdminReleases = (function() {

    function ULoadAdminReleases() {}

    ULoadAdminReleases.prototype.execute = function(jsonRels, jsonProjects) {
      var loadReleases, projects, releases;
      loadReleases = new HLoadReleases();
      releases = loadReleases.execute(jsonRels);
      projects = Project.createCollection(jsonProjects);
      this.viewModel = new AdminReleaseViewmodel(releases, projects);
      this.viewModel.selectRelease(this.viewModel.allReleases()[0]);
      return ko.applyBindings(this.viewModel, null, {
        independentBindings: true
      });
    };

    return ULoadAdminReleases;

  })();

  ULoadAdminProjects = (function() {

    function ULoadAdminProjects() {}

    ULoadAdminProjects.prototype.execute = function(data) {
      var projects;
      projects = Project.createCollection(data);
      this.viewModel = new AdminProjectViewmodel(projects);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminProjects;

  })();

  ULoadAdminResources = (function() {

    function ULoadAdminResources() {}

    ULoadAdminResources.prototype.execute = function(data) {
      var resources;
      resources = Resource.createCollection(data);
      this.viewModel = new AdminResourceViewmodel(resources);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminResources;

  })();

  ULoadPlanResources = (function() {

    function ULoadPlanResources() {}

    ULoadPlanResources.prototype.execute = function(releases, resources) {
      var loadReleases;
      loadReleases = new HLoadReleases();
      releases = loadReleases.execute(releases);
      resources = Resource.createCollection(resources);
      this.viewModel = new PlanResourcesViewmodel(releases, resources);
      this.viewModel.selectRelease(this.viewModel.allReleases()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadPlanResources;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

  root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow;

  root.UDisplayPhases = UDisplayPhases;

  root.HLoadReleases = HLoadReleases;

  root.ULoadAdminReleases = ULoadAdminReleases;

  root.ULoadAdminProjects = ULoadAdminProjects;

  root.ULoadAdminResources = ULoadAdminResources;

  root.ULoadPlanResources = ULoadPlanResources;

}).call(this);
