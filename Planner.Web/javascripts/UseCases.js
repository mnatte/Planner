(function() {
  var HLoadProjects, HLoadReleases, HLoadResources, UDisplayPhases, UDisplayReleaseStatus, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  HLoadReleases = (function() {

    function HLoadReleases() {}

    HLoadReleases.prototype.execute = function(data) {
      var phase, release, releases, _i, _j, _len, _len2, _ref;
      releases = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        release = data[_i];
        this.release = new Release(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title, release.TfsIterationPath);
        _ref = release.Phases;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          phase = _ref[_j];
          console.log(phase);
          this.release.addPhase(new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, release.Id));
        }
        releases.push(this.release);
      }
      return releases;
    };

    return HLoadReleases;

  })();

  HLoadProjects = (function() {

    function HLoadProjects() {}

    HLoadProjects.prototype.execute = function(data) {
      var project, projects, _i, _len;
      projects = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        project = data[_i];
        this.project = new Project(project.Id, project.Title, project.ShortName, project.Description, project.TfsIterationPath, project.TfsDevBranch);
        projects.push(this.project);
      }
      return projects;
    };

    return HLoadProjects;

  })();

  HLoadResources = (function() {

    function HLoadResources() {}

    HLoadResources.prototype.execute = function(data) {
      var resource, resources, _i, _len;
      resources = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        resource = data[_i];
        this.resource = new Resource(resource.Id, resource.FirstName, resource.MiddleName, resource.LastName, resource.Initials, resource.AvailableHoursPerWeek, resource.Email, resource.PhoneNumber);
        resources.push(this.resource);
      }
      return resources;
    };

    return HLoadResources;

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
          teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Email, member.PhoneNumber, member.Company, member.Function);
          teamMember.focusFactor = member.FocusFactor;
          teamMember.memberProject = feat.Project.ShortName;
          _ref5 = member.PeriodsAway;
          for (_l = 0, _len4 = _ref5.length; _l < _len4; _l++) {
            absence = _ref5[_l];
            if (DateFormatter.createJsDateFromJson(absence.EndDate) < this.release.endDate || DateFormatter.createJsDateFromJson(absence.StartDate) >= this.release.startDate) {
              teamMember.addAbsence(new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title));
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
      restPeriod = new Period(today, this.phase.endDate.date, this.phase.title);
      absentHours = 0;
      _ref = this.teamMember.periodsAway;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        absence = _ref[_i];
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

  ULoadAdminReleases = (function() {

    function ULoadAdminReleases() {}

    ULoadAdminReleases.prototype.execute = function(data) {
      var loadReleases, releases;
      loadReleases = new HLoadReleases();
      releases = loadReleases.execute(data);
      this.viewModel = new AdminReleaseViewmodel(releases);
      console.log(this.viewModel);
      this.viewModel.selectRelease(this.viewModel.allReleases()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminReleases;

  })();

  ULoadAdminProjects = (function() {

    function ULoadAdminProjects() {}

    ULoadAdminProjects.prototype.execute = function(data) {
      var loadProjects, projects;
      loadProjects = new HLoadProjects();
      projects = loadProjects.execute(data);
      this.viewModel = new AdminProjectViewmodel(projects);
      console.log(this.viewModel);
      this.viewModel.selectProject(this.viewModel.allProjects()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminProjects;

  })();

  ULoadAdminResources = (function() {

    function ULoadAdminResources() {}

    ULoadAdminResources.prototype.execute = function(data) {
      var load, resources;
      load = new HLoadResources();
      resources = load.execute(data);
      this.viewModel = new AdminResourceViewmodel(resources);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminResources;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

  root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow;

  root.UDisplayPhases = UDisplayPhases;

  root.HLoadReleases = HLoadReleases;

  root.ULoadAdminReleases = ULoadAdminReleases;

  root.HLoadProjects = HLoadProjects;

  root.ULoadAdminProjects = ULoadAdminProjects;

  root.HLoadResources = HLoadResources;

  root.ULoadAdminResources = ULoadAdminResources;

}).call(this);
