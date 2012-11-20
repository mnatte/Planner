(function() {
  var UDisplayAbsences, UDisplayPhases, UDisplayPlanningOverview, UDisplayReleaseStatus, UDisplayResourcesAvailability, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminActivities, ULoadAdminDeliverables, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, ULoadPlanResources, ULoadUpdateReleaseStatus, UReloadAbsenceInTimeline, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

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
      var releases;
      releases = Release.createCollection(data);
      this.viewModel = new PhasesViewmodel(releases);
      this.viewModel.load(releases.sort(function(a, b) {
        return a.startDate.date - b.startDate.date;
      }));
      ko.applyBindings(this.viewModel);
      return drawTimeline(this.viewModel.showPhases);
    };

    return UDisplayPhases;

  })();

  UDisplayAbsences = (function() {

    function UDisplayAbsences() {}

    UDisplayAbsences.prototype.execute = function(data) {
      var resources;
      resources = Resource.createCollection(data);
      this.viewModel = new AbsencesViewmodel(resources);
      this.viewModel.load(resources.sort());
      ko.applyBindings(this.viewModel);
      return drawTimeline(this.viewModel.showAbsences, this.viewModel.selectedTimelineItem);
    };

    return UDisplayAbsences;

  })();

  UReloadAbsenceInTimeline = (function() {

    function UReloadAbsenceInTimeline(allAbsences, index, refreshedTimelineItem) {
      this.allAbsences = allAbsences;
      this.index = index;
      this.refreshedTimelineItem = refreshedTimelineItem;
    }

    UReloadAbsenceInTimeline.prototype.execute = function() {
      return drawTimeline(allAbsences, refreshedTimelineItem);
    };

    return UReloadAbsenceInTimeline;

  })();

  ULoadAdminReleases = (function() {

    function ULoadAdminReleases() {}

    ULoadAdminReleases.prototype.execute = function(jsonRels, jsonProjects, jsonDeliverables) {
      var deliverables, projects, releases;
      releases = Release.createCollection(jsonRels);
      projects = Project.createCollection(jsonProjects);
      deliverables = Deliverable.createCollection(jsonDeliverables);
      this.viewModel = new AdminReleaseViewmodel(releases, projects, deliverables);
      this.viewModel.selectRelease(this.viewModel.allReleases()[0]);
      return ko.applyBindings(this.viewModel, null, {
        independentBindings: true
      });
    };

    return ULoadAdminReleases;

  })();

  ULoadUpdateReleaseStatus = (function() {

    function ULoadUpdateReleaseStatus() {}

    ULoadUpdateReleaseStatus.prototype.execute = function(jsonRels) {
      var releases;
      releases = Release.createCollection(jsonRels);
      this.viewModel = new UpdateReleaseStatusViewmodel(releases);
      this.viewModel.selectRelease(this.viewModel.allReleases[0]);
      return ko.applyBindings(this.viewModel, null, {
        independentBindings: true
      });
    };

    return ULoadUpdateReleaseStatus;

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

  UDisplayPlanningOverview = (function() {

    function UDisplayPlanningOverview() {}

    UDisplayPlanningOverview.prototype.execute = function(data) {
      var resources;
      resources = Resource.createCollection(data);
      this.viewModel = new PlanningOverviewViewmodel(resources);
      return ko.applyBindings(this.viewModel);
    };

    return UDisplayPlanningOverview;

  })();

  UDisplayResourcesAvailability = (function() {

    function UDisplayResourcesAvailability() {}

    UDisplayResourcesAvailability.prototype.execute = function(data) {
      var resources;
      resources = Resource.createCollection(data);
      this.viewModel = new ResourceAvailabilityViewmodel(resources);
      return ko.applyBindings(this.viewModel);
    };

    return UDisplayResourcesAvailability;

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

    ULoadAdminDeliverables.prototype.execute = function(acts, data) {
      var activities, deliverables;
      deliverables = Deliverable.createCollection(data);
      activities = Activity.createCollection(acts);
      this.viewModel = new AdminDeliverableViewmodel(deliverables, activities);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminDeliverables;

  })();

  ULoadAdminActivities = (function() {

    function ULoadAdminActivities() {}

    ULoadAdminActivities.prototype.execute = function(data) {
      var items;
      items = Activity.createCollection(data);
      this.viewModel = new AdminActivityViewmodel(items);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminActivities;

  })();

  ULoadPlanResources = (function() {

    function ULoadPlanResources() {}

    ULoadPlanResources.prototype.execute = function(releases, resources, activities) {
      releases = Release.createCollection(releases);
      console.log(releases);
      resources = Resource.createCollection(resources);
      activities = Activity.createCollection(activities);
      this.viewModel = new PlanResourcesViewmodel(releases, resources, activities);
      this.viewModel.selectRelease(this.viewModel.allReleases()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadPlanResources;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

  root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow;

  root.UDisplayPhases = UDisplayPhases;

  root.UDisplayAbsences = UDisplayAbsences;

  root.UDisplayPlanningOverview = UDisplayPlanningOverview;

  root.UDisplayResourcesAvailability = UDisplayResourcesAvailability;

  root.ULoadAdminReleases = ULoadAdminReleases;

  root.ULoadAdminProjects = ULoadAdminProjects;

  root.ULoadAdminResources = ULoadAdminResources;

  root.ULoadAdminDeliverables = ULoadAdminDeliverables;

  root.ULoadAdminActivities = ULoadAdminActivities;

  root.ULoadPlanResources = ULoadPlanResources;

  root.ULoadUpdateReleaseStatus = ULoadUpdateReleaseStatus;

}).call(this);
