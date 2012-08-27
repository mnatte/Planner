(function() {
  var HLoadReleases, UDisplayPhases, UDisplayReleaseStatus, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminDeliverables, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, ULoadPlanResources, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  HLoadReleases = (function() {

    function HLoadReleases() {}

    HLoadReleases.prototype.execute = function(data) {
      var rel, release, releases, _i, _len;
      releases = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        release = data[_i];
        rel = Release.create(release);
        releases.push(rel);
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
      var proj, releaseBacklog, _i, _len, _ref;
      this.release = Release.create(data);
      document.title = data.Title;
      releaseBacklog = [];
      _ref = this.release.projects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        proj = _ref[_i];
        releaseBacklog = releaseBacklog.concat(proj.backlog);
      }
      this.release.group('state', releaseBacklog);
      this.viewModel = new ReleaseViewmodel(this.release);
      ko.applyBindings(this.viewModel);
      this.viewModel.selectedPhaseId(this.viewModel.release.phases[0].id);
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
        if (today > this.phase.startDate.date && today > (member.startDate = today)) {} else {
          startDate = this.phase.startDate.date;
        }
        restPeriod = new Period(startDate, this.phase.endDate.date, this.phase.title);
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

  ULoadAdminDeliverables = (function() {

    function ULoadAdminDeliverables() {}

    ULoadAdminDeliverables.prototype.execute = function(data) {
      var deliverables;
      deliverables = Deliverable.createCollection(data);
      this.viewModel = new AdminDeliverableViewmodel(deliverables);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminDeliverables;

  })();

  ULoadPlanResources = (function() {

    function ULoadPlanResources() {}

    ULoadPlanResources.prototype.execute = function(releases, resources) {
      var loadReleases;
      loadReleases = new HLoadReleases();
      releases = loadReleases.execute(releases);
      console.log(releases);
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

  root.ULoadAdminDeliverables = ULoadAdminDeliverables;

  root.ULoadPlanResources = ULoadPlanResources;

}).call(this);
