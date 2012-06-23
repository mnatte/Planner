(function() {
  var HLoadReleases, UDisplayPhases, UDisplayReleaseStatus, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, ULoadPlanResources, root;

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
      var absence, member, proj, projectMembers, teamMember, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      projectMembers = [];
      console.log(data);
      this.release = Release.create(data);
      document.title = data.Title;
      console.log(this.release.backlog);
      _ref = data.Projects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        proj = _ref[_i];
        console.log(ko.toJSON(proj));
        _ref2 = proj.AssignedResources;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          member = _ref2[_j];
          console.log(ko.toJSON(member));
          teamMember = Resource.create(member);
          teamMember.focusFactor = member.FocusFactor;
          teamMember.memberProject = feat.Project.ShortName;
          _ref3 = member.PeriodsAway;
          for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
            absence = _ref3[_k];
            if (DateFormatter.createJsDateFromJson(absence.EndDate) < this.release.endDate.date || DateFormatter.createJsDateFromJson(absence.StartDate) >= this.release.startDate.date) {
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
      return showStatusChart(this.viewModel.statusData());
    };

    return UDisplayReleaseStatus;

  })();

  UGetAvailableHoursForTeamMemberFromNow = (function() {

    function UGetAvailableHoursForTeamMemberFromNow(teamMember, phase) {
      this.teamMember = teamMember;
      this.phase = phase;
    }

    UGetAvailableHoursForTeamMemberFromNow.prototype.execute = function() {
      var absence, absentHours, availableHours, periodAway, remainingAbsence, restPeriod, start, startDate, today, _i, _len, _ref;
      today = new Date();
      if (today > this.phase.endDate.date) {
        return 0;
      } else {
        console.log("available hours for: " + this.teamMember.initials);
        console.log("in phase: " + (this.phase.toString()));
        if (today > this.phase.startDate.date && today > (member.startDate = today)) {} else {
          startDate = this.phase.startDate.date;
        }
        restPeriod = new Period(startDate, this.phase.endDate.date, this.phase.title);
        console.log("period from now: " + restPeriod);
        absentHours = 0;
        _ref = this.teamMember.periodsAway;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          absence = _ref[_i];
          if (!(absence.overlaps(this.phase))) continue;
          periodAway = absence.overlappingPeriod(this.phase);
          if (today > absence.startDate.date) {
            start = today;
          } else {
            start = absence.startDate.date;
          }
          remainingAbsence = new Period(start, periodAway.endDate.date, 'remaining absence from now');
          absentHours += remainingAbsence.workingHours();
        }
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
