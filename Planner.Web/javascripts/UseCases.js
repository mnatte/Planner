(function() {
  var UAjax, UCreateVisualCuesForAbsences, UCreateVisualCuesForGates, UDeleteAssignment, UDisplayAbsences, UDisplayAssignments, UDisplayBurndown, UDisplayEnvironments, UDisplayPhases, UDisplayPlanningForResource, UDisplayPlanningOverview, UDisplayReleaseOverview, UDisplayReleasePhases, UDisplayReleasePlanningInTimeline, UDisplayReleaseProgress, UDisplayReleaseProgressOverview, UDisplayReleaseStatus, UDisplayReleaseTimeline, UDisplayResourcesAvailability, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminActivities, ULoadAdminDeliverables, ULoadAdminMeetings, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, ULoadPlanResources, ULoadUpdateReleaseStatus, UModifyAssignment, UPersistAndRefresh, URefreshView, URefreshViewAfterCheckPeriod, UReloadAbsenceInTimeline, URescheduleMilestone, UReschedulePhase, UUpdateDeliverableStatus, UUpdateScreen, root,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

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
      var releases, timeline;
      releases = Release.createCollection(data);
      this.viewModel = new PhasesViewmodel(releases);
      this.viewModel.load(releases.sort(function(a, b) {
        return a.startDate.date - b.startDate.date;
      }));
      ko.applyBindings(this.viewModel);
      timeline = new Mnd.Timeline(this.viewModel.showPhases, this.viewModel.selectedTimelineItem);
      return timeline.draw();
    };

    return UDisplayPhases;

  })();

  UDisplayEnvironments = (function() {

    function UDisplayEnvironments() {}

    UDisplayEnvironments.prototype.execute = function(envsJson, versionsJson) {
      var env, environments, obj, pl, timeline, versions, _i, _j, _len, _len2, _ref;
      environments = Environment.createCollection(envsJson);
      versions = Version.createCollection(versionsJson);
      console.log(environments);
      this.displayData = [];
      for (_i = 0, _len = environments.length; _i < _len; _i++) {
        env = environments[_i];
        _ref = env.planning;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          pl = _ref[_j];
          obj = {
            group: env.name,
            start: pl.phase.startDate.date,
            end: pl.phase.endDate.date,
            content: pl.version.number,
            info: pl.phase.toString(),
            dataObject: pl
          };
          this.displayData.push(obj);
        }
      }
      this.viewModel = new EnvironmentsPlanningViewmodel(environments, versions);
      ko.applyBindings(this.viewModel);
      timeline = new Mnd.Timeline(this.displayData, this.viewModel.selectedTimelineItem);
      return timeline.draw();
    };

    return UDisplayEnvironments;

  })();

  UAjax = (function() {

    function UAjax(callBack) {
      this.callBack = callBack;
    }

    UAjax.prototype.execute = function() {
      throw new Error('Abstract method execute of UAjax UseCase');
    };

    UAjax.prototype.refreshData = function(json) {
      console.log(json);
      return this.callBack(json);
    };

    return UAjax;

  })();

  UCreateVisualCuesForGates = (function(_super) {

    __extends(UCreateVisualCuesForGates, _super);

    function UCreateVisualCuesForGates(amountDays, callBack) {
      this.amountDays = amountDays;
      this.callBack = callBack;
      UCreateVisualCuesForGates.__super__.constructor.call(this, this.callBack);
    }

    UCreateVisualCuesForGates.prototype.execute = function() {
      var ajx,
        _this = this;
      ajx = new Ajax();
      return ajx.createCuesForGates(this.amountDays, function(json) {
        return _this.refreshData(json);
      });
    };

    return UCreateVisualCuesForGates;

  })(UAjax);

  UCreateVisualCuesForAbsences = (function(_super) {

    __extends(UCreateVisualCuesForAbsences, _super);

    function UCreateVisualCuesForAbsences(amountDays, callBack) {
      this.amountDays = amountDays;
      this.callBack = callBack;
      UCreateVisualCuesForAbsences.__super__.constructor.call(this, this.callBack);
    }

    UCreateVisualCuesForAbsences.prototype.execute = function() {
      var ajx,
        _this = this;
      ajx = new Ajax();
      return ajx.createCuesForAbsences(this.amountDays, function(json) {
        return _this.refreshData(json);
      });
    };

    return UCreateVisualCuesForAbsences;

  })(UAjax);

  UDisplayAbsences = (function() {

    function UDisplayAbsences() {}

    UDisplayAbsences.prototype.execute = function(data) {
      var resources, timeline;
      resources = Resource.createCollection(data);
      this.viewModel = new AbsencesViewmodel(resources);
      this.viewModel.load(resources.sort());
      ko.applyBindings(this.viewModel);
      timeline = new Mnd.Timeline(this.viewModel.showAbsences, this.viewModel.selectedTimelineItem, "100%", "1000px");
      return timeline.draw();
    };

    return UDisplayAbsences;

  })();

  UDisplayAssignments = (function() {

    function UDisplayAssignments() {}

    UDisplayAssignments.prototype.execute = function(data) {
      var resources, timeline;
      resources = Resource.createCollection(data);
      this.viewModel = new AssignmentsViewmodel(resources);
      this.viewModel.load(resources.sort());
      ko.applyBindings(this.viewModel);
      timeline = new Mnd.Timeline(this.viewModel.showAssignments, this.viewModel.selectedTimelineItem);
      return timeline.draw();
    };

    return UDisplayAssignments;

  })();

  UReloadAbsenceInTimeline = (function() {

    function UReloadAbsenceInTimeline(allAbsences, index, refreshedTimelineItem) {
      this.allAbsences = allAbsences;
      this.index = index;
      this.refreshedTimelineItem = refreshedTimelineItem;
    }

    UReloadAbsenceInTimeline.prototype.execute = function() {
      var timeline;
      timeline = new Mnd.Timeline(allAbsences, refreshedTimelineItem);
      return timeline.draw();
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

  ULoadAdminMeetings = (function() {

    function ULoadAdminMeetings() {}

    ULoadAdminMeetings.prototype.execute = function(data) {
      var items;
      items = Meeting.createCollection(data);
      this.viewModel = new AdminMeetingViewmodel(items);
      this.viewModel.selectItem(this.viewModel.allItems()[0]);
      return ko.applyBindings(this.viewModel);
    };

    return ULoadAdminMeetings;

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

  UDisplayReleaseOverview = (function() {

    function UDisplayReleaseOverview() {}

    UDisplayReleaseOverview.prototype.execute = function(rels, resources, activities) {
      var allActivities, allResources, releases;
      releases = Release.createCollection(rels);
      allResources = Resource.createCollection(resources);
      allActivities = Activity.createCollection(activities);
      console.log(releases);
      this.viewModel = new ReleaseOverviewViewmodel(releases, allResources, allActivities);
      return ko.applyBindings(this.viewModel);
    };

    return UDisplayReleaseOverview;

  })();

  UDisplayPlanningForResource = (function() {

    function UDisplayPlanningForResource(resource, period) {
      this.resource = resource;
      this.period = period;
    }

    UDisplayPlanningForResource.prototype.execute = function() {
      var abs, absence, ass, assignment, displayData, dto, i, obj, showAssignments, timeline, _i, _j, _len, _len2, _ref, _ref2;
      displayData = [];
      console.log(this.resource.fullName());
      i = 0;
      _ref = (function() {
        var _j, _len, _ref, _results;
        _ref = this.resource.periodsAway;
        _results = [];
        for (_j = 0, _len = _ref.length; _j < _len; _j++) {
          abs = _ref[_j];
          if (abs.overlaps(this.period)) _results.push(abs);
        }
        return _results;
      }).call(this);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        absence = _ref[_i];
        dto = absence;
        dto.person = this.resource;
        obj = {
          group: this.resource.fullName() + '[' + i + ']',
          start: absence.startDate.date,
          end: absence.endDate.date,
          content: absence.title,
          info: absence.toString(),
          dataObject: dto
        };
        displayData.push(obj);
        i++;
      }
      _ref2 = (function() {
        var _k, _len2, _ref2, _results;
        _ref2 = this.resource.assignments;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          ass = _ref2[_k];
          if (ass.period.overlaps(this.period)) _results.push(ass);
        }
        return _results;
      }).call(this);
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        assignment = _ref2[_j];
        dto = assignment;
        dto.person = this.resource;
        obj = {
          group: this.resource.fullName() + '[' + i + ']',
          start: assignment.period.startDate.date,
          end: assignment.period.endDate.date,
          content: assignment.period.title,
          info: assignment.period.toString(),
          dataObject: dto
        };
        displayData.push(obj);
        i++;
      }
      showAssignments = displayData.sort(function(a, b) {
        return a.start - b.end;
      });
      timeline = new Mnd.Timeline(showAssignments, null, "100%", "200px", "resourceTimeline", "resourceDetails");
      return timeline.draw();
    };

    return UDisplayPlanningForResource;

  })();

  URefreshView = (function() {

    function URefreshView(selectedObservable, checkPeriod) {
      this.selectedObservable = selectedObservable;
      this.checkPeriod = checkPeriod;
    }

    URefreshView.prototype.execute = function() {
      var a, resWithAssAndAbsInDate;
      resWithAssAndAbsInDate = this.selectedObservable();
      resWithAssAndAbsInDate.assignments = (function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedObservable().assignments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.period.overlaps(this.checkPeriod)) _results.push(a);
        }
        return _results;
      }).call(this);
      resWithAssAndAbsInDate.periodsAway = (function() {
        var _i, _len, _ref, _results;
        _ref = this.selectedObservable().periodsAway;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.overlaps(this.checkPeriod)) _results.push(a);
        }
        return _results;
      }).call(this);
      return this.selectedObservable(resWithAssAndAbsInDate);
    };

    return URefreshView;

  })();

  URefreshViewAfterCheckPeriod = (function() {

    function URefreshViewAfterCheckPeriod(checkPeriod, viewModelObservableGraph, viewModelObservableForm) {
      this.checkPeriod = checkPeriod;
      this.viewModelObservableGraph = viewModelObservableGraph;
      this.viewModelObservableForm = viewModelObservableForm;
    }

    URefreshViewAfterCheckPeriod.prototype.execute = function() {
      this.viewModelObservableGraph(null);
      return this.viewModelObservableForm(null);
    };

    return URefreshViewAfterCheckPeriod;

  })();

  UPersistAndRefresh = (function() {

    function UPersistAndRefresh(viewModelObservableCollection, selectedObservable, updateViewUsecase, observableShowform, dehydrate) {
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.selectedObservable = selectedObservable;
      this.updateViewUsecase = updateViewUsecase;
      this.observableShowform = observableShowform;
      this.dehydrate = dehydrate;
    }

    UPersistAndRefresh.prototype.execute = function() {
      throw new Error('Abstract method execute of UPersistAndRefresh UseCase');
    };

    UPersistAndRefresh.prototype.refreshData = function(json) {
      var index, oldItem, r, refreshed, _i, _len, _ref;
      console.log(json);
      console.log(this.dehydrate);
      if (this.dehydrate && this.viewModelObservableCollection) {
        refreshed = this.dehydrate(json);
        _ref = this.viewModelObservableCollection();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          r = _ref[_i];
          if (r.id === refreshed.id) oldItem = r;
        }
        index = this.viewModelObservableCollection().indexOf(oldItem);
        this.viewModelObservableCollection.splice(index, 1, refreshed);
        this.selectedObservable(refreshed);
      }
      if (this.observableShowform) this.observableShowform(null);
      if (this.updateViewUsecase) return this.updateViewUsecase.execute();
    };

    return UPersistAndRefresh;

  })();

  URescheduleMilestone = (function(_super) {

    __extends(URescheduleMilestone, _super);

    function URescheduleMilestone(milestone, viewModelObservableCollection, selectedObservable, updateViewUsecase, observableShowform, dehydrate) {
      this.milestone = milestone;
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.selectedObservable = selectedObservable;
      this.updateViewUsecase = updateViewUsecase;
      this.observableShowform = observableShowform;
      this.dehydrate = dehydrate;
      URescheduleMilestone.__super__.constructor.call(this, this.viewModelObservableCollection, this.selectedObservable, this.updateViewUsecase, this.observableShowform, this.dehydrate);
    }

    URescheduleMilestone.prototype.execute = function() {
      var _this = this;
      Milestone.extend(RScheduleItem);
      Milestone.setScheduleUrl("/planner/Release/Milestone/Schedule");
      console.log('execute URescheduleMilestone');
      return this.milestone.schedule(this.milestone.id, this.milestone.phaseId, this.milestone.date.dateString, this.milestone.time, function(data) {
        return _this.refreshData(data);
      });
    };

    return URescheduleMilestone;

  })(UPersistAndRefresh);

  UReschedulePhase = (function(_super) {

    __extends(UReschedulePhase, _super);

    function UReschedulePhase(phase, viewModelObservableCollection, selectedObservable, updateViewUsecase, observableShowform, dehydrate) {
      this.phase = phase;
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.selectedObservable = selectedObservable;
      this.updateViewUsecase = updateViewUsecase;
      this.observableShowform = observableShowform;
      this.dehydrate = dehydrate;
      UReschedulePhase.__super__.constructor.call(this, this.viewModelObservableCollection, this.selectedObservable, this.updateViewUsecase, this.observableShowform, this.dehydrate);
    }

    UReschedulePhase.prototype.execute = function() {
      var _this = this;
      Phase.extend(RSchedulePeriod);
      Phase.setScheduleUrl("/planner/Release/Phase/Schedule");
      console.log('execute UReschedulePhase');
      return this.phase.schedule(this.phase.id, this.phase.parentId, this.phase.startDate.dateString, this.phase.endDate.dateString, function(data) {
        return _this.refreshData(data);
      });
    };

    return UReschedulePhase;

  })(UPersistAndRefresh);

  UModifyAssignment = (function(_super) {

    __extends(UModifyAssignment, _super);

    function UModifyAssignment(assignment, viewModelObservableCollection, selectedObservable, updateViewUsecase, observableShowform, sourceView, dehydrate) {
      this.assignment = assignment;
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.selectedObservable = selectedObservable;
      this.updateViewUsecase = updateViewUsecase;
      this.observableShowform = observableShowform;
      this.sourceView = sourceView;
      this.dehydrate = dehydrate;
      UModifyAssignment.__super__.constructor.call(this, this.viewModelObservableCollection, this.selectedObservable, this.updateViewUsecase, this.observableShowform, this.dehydrate);
    }

    UModifyAssignment.prototype.execute = function() {
      var json,
        _this = this;
      console.log('execute UModifyAssignment');
      console.log(this.assignment);
      json = ko.toJSON(this.assignment);
      console.log(json);
      console.log(this.sourceView);
      if (this.sourceView === "release") {
        return this.assignment.resource.planForRelease(this.assignment.release, this.assignment.project, this.assignment.milestone, this.assignment.deliverable, this.assignment.activity, this.assignment.period, this.assignment.focusFactor, function(data) {
          return _this.refreshData(data);
        });
      } else if (this.sourceView === "resource") {
        return this.assignment.resource.plan(this.assignment.release, this.assignment.project, this.assignment.milestone, this.assignment.deliverable, this.assignment.activity, this.assignment.period, this.assignment.focusFactor, function(data) {
          return _this.refreshData(data);
        });
      }
    };

    return UModifyAssignment;

  })(UPersistAndRefresh);

  UDeleteAssignment = (function(_super) {

    __extends(UDeleteAssignment, _super);

    function UDeleteAssignment(assignment, viewModelObservableCollection, selectedObservable, updateViewUsecase, observableShowform, sourceView, dehydrate) {
      this.assignment = assignment;
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.selectedObservable = selectedObservable;
      this.updateViewUsecase = updateViewUsecase;
      this.observableShowform = observableShowform;
      this.sourceView = sourceView;
      this.dehydrate = dehydrate;
      UDeleteAssignment.__super__.constructor.call(this, this.viewModelObservableCollection, this.selectedObservable, this.updateViewUsecase, this.observableShowform, this.dehydrate);
    }

    UDeleteAssignment.prototype.execute = function() {
      var json,
        _this = this;
      console.log('execute UDeleteResourceAssignment');
      json = ko.toJSON(this.assignment);
      console.log(json);
      if (this.sourceView === "release") {
        return this.assignment.resource.unassignFromRelease(this.assignment.release, this.assignment.project, this.assignment.milestone, this.assignment.deliverable, this.assignment.activity, this.assignment.period, function(data) {
          return _this.refreshData(data);
        });
      } else if (this.sourceView === "resource") {
        return this.assignment.resource.unassign(this.assignment.release, this.assignment.project, this.assignment.milestone, this.assignment.deliverable, this.assignment.activity, this.assignment.period, function(data) {
          return _this.refreshData(data);
        });
      }
    };

    return UDeleteAssignment;

  })(UPersistAndRefresh);

  UUpdateDeliverableStatus = (function(_super) {

    __extends(UUpdateDeliverableStatus, _super);

    function UUpdateDeliverableStatus(selectedDeliverable, viewModelObservableCollection, selectedObservable, updateViewUsecase, observableShowform, sourceView, dehydrate) {
      this.selectedDeliverable = selectedDeliverable;
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.selectedObservable = selectedObservable;
      this.updateViewUsecase = updateViewUsecase;
      this.observableShowform = observableShowform;
      this.sourceView = sourceView;
      this.dehydrate = dehydrate;
      UUpdateDeliverableStatus.__super__.constructor.call(this, this.viewModelObservableCollection, this.selectedObservable, this.updateViewUsecase, this.observableShowform, this.dehydrate);
    }

    UUpdateDeliverableStatus.prototype.execute = function() {
      var status,
        _this = this;
      Deliverable.extend(RCrud);
      Deliverable.extend(RDeliverableSerialize);
      Project.extend(RProjectSerialize);
      ProjectActivityStatus.extend(RProjectActivityStatusSerialize);
      status = this.selectedDeliverable.toStatusJSON();
      console.log(ko.toJSON(status));
      return this.selectedDeliverable.save("/planner/Release/SaveDeliverableStatus", ko.toJSON(status), function(data) {
        return _this.refreshData(data);
      });
    };

    return UUpdateDeliverableStatus;

  })(UPersistAndRefresh);

  UUpdateScreen = (function() {

    function UUpdateScreen(usecases, delegates) {
      this.usecases = usecases;
      this.delegates = delegates;
    }

    UUpdateScreen.prototype.execute = function() {
      var del, uc, _i, _j, _len, _len2, _ref, _ref2, _results;
      if (this.usecases) {
        _ref = this.usecases;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          uc = _ref[_i];
          uc.execute();
        }
      }
      if (this.delegates) {
        _ref2 = this.delegates;
        _results = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          del = _ref2[_j];
          del();
          _results.push(true);
        }
        return _results;
      }
    };

    return UUpdateScreen;

  })();

  UDisplayReleaseTimeline = (function() {

    function UDisplayReleaseTimeline(observableRelease, observableTimelineSource) {
      this.observableRelease = observableRelease;
      this.observableTimelineSource = observableTimelineSource;
    }

    UDisplayReleaseTimeline.prototype.execute = function() {
      var act, activities, cont, del, descr, icon, ms, obj, ph, proj, showData, style, timeline, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4;
      this.displayData = [];
      console.log('execute use case UDisplayReleaseTimeline');
      _ref = this.observableRelease().phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ph = _ref[_i];
        cont = ph.title;
        obj = {
          group: this.observableRelease().title,
          start: ph.startDate.date,
          end: ph.endDate.date,
          content: cont,
          info: ph.toString(),
          dataObject: ph
        };
        this.displayData.push(obj);
      }
      _ref2 = this.observableRelease().milestones;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        ms = _ref2[_j];
        icon = '<span class="icon icon-milestone" />';
        style = 'style="color: green"';
        descr = '<ul>';
        _ref3 = ms.deliverables;
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          del = _ref3[_k];
          descr += '<li>' + del.title + '<ul>';
          _ref4 = del.scope;
          for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
            proj = _ref4[_l];
            descr += '<li>' + proj.title;
            descr += '<ul>';
            activities = proj.workload.reduce(function(acc, x) {
              acc.push({
                activityTitle: x.activity.title,
                hrs: x.hoursRemaining,
                planned: x.assignedResources.reduce((function(acc, x) {
                  return acc + x.resourceAvailableHours();
                }), 0)
              });
              return acc;
            }, []);
            for (_m = 0, _len5 = activities.length; _m < _len5; _m++) {
              act = activities[_m];
              if (act.hrs > act.planned) {
                icon = '<span class="icon icon-warning" />';
                style = 'style="color: red"';
              } else {
                style = 'style="color: green"';
              }
              descr += '<li ' + style + '>' + act.activityTitle + ': ' + act.hrs + ' hours remaining, ' + act.planned + ' hours planned</li>';
            }
            descr += '</ul>';
            descr += '</li>';
          }
          descr += '</ul>';
        }
        descr += '</li>';
        descr += '</ul>';
        ms.release = {
          id: this.observableRelease().id,
          title: this.observableRelease().title
        };
        obj = {
          group: this.observableRelease().title,
          start: ms.date.date,
          content: ms.title + '<br />' + icon,
          info: ms.date.dateString + ' - ' + ms.time + '<br />' + descr,
          dataObject: ms
        };
        this.displayData.push(obj);
      }
      showData = this.displayData.sort(function(a, b) {
        return a.start - b.end;
      });
      console.log(showData);
      timeline = new Mnd.Timeline(showData, this.observableTimelineSource, "100%", "200px", "releaseTimeline", "releaseDetails");
      timeline.draw();
      return timeline.clearDetails();
    };

    return UDisplayReleaseTimeline;

  })();

  UDisplayReleasePlanningInTimeline = (function() {

    function UDisplayReleasePlanningInTimeline(observableRelease, observableTimelineItem) {
      this.observableRelease = observableRelease;
      this.observableTimelineItem = observableTimelineItem;
    }

    UDisplayReleasePlanningInTimeline.prototype.execute = function() {
      var activity, assignment, del, dto, ms, obj, proj, releaseTitle, resource, showData, timeline, uniqueAsses, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4, _ref5;
      this.trackAssignments = [];
      this.displayData = [];
      releaseTitle = this.observableRelease().title;
      console.log('execute use case UDisplayReleasePlanningInTimeline');
      console.log(this.observableRelease());
      uniqueAsses = [];
      _ref = this.observableRelease().milestones;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ms = _ref[_i];
        _ref2 = ms.deliverables;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          del = _ref2[_j];
          console.log(del);
          _ref3 = del.scope;
          for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
            proj = _ref3[_k];
            _ref4 = proj.workload;
            for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
              activity = _ref4[_l];
              _ref5 = activity.assignedResources;
              for (_m = 0, _len5 = _ref5.length; _m < _len5; _m++) {
                assignment = _ref5[_m];
                console.log(assignment);
                dto = assignment;
                resource = this.createRowItem(assignment.resource.fullName(), 0);
                obj = {
                  group: resource,
                  start: assignment.period.startDate.date,
                  end: assignment.period.endDate.date,
                  content: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.project.title,
                  info: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.period.toString(),
                  dataObject: dto
                };
                this.displayData.push(obj);
              }
            }
          }
        }
      }
      showData = this.displayData.sort(function(a, b) {
        return a.start - b.end;
      });
      timeline = new Mnd.Timeline(showData, this.observableTimelineItem, "100%", "800px", "resourcePlanning", "assignmentDetails");
      timeline.draw();
      return timeline.clearDetails();
    };

    UDisplayReleasePlanningInTimeline.prototype.createRowItem = function(item, index) {
      var identifier;
      identifier = item + index;
      if (this.trackAssignments.indexOf(identifier) === -1) {
        this.trackAssignments.push(identifier);
        return item + '[' + index + ']';
      } else {
        index++;
        return this.createRowItem(item, index);
      }
    };

    return UDisplayReleasePlanningInTimeline;

  })();

  UDisplayReleasePhases = (function() {

    function UDisplayReleasePhases(release, viewModelObservableGraph) {
      this.release = release;
      this.viewModelObservableGraph = viewModelObservableGraph;
    }

    UDisplayReleasePhases.prototype.execute = function() {
      var timeline;
      this.viewModel = new PhasesViewmodel(releases);
      this.viewModel.load(releases.sort(function(a, b) {
        return a.startDate.date - b.startDate.date;
      }));
      ko.applyBindings(this.viewModel);
      timeline = new Mnd.Timeline(this.viewModel.showPhases);
      return timeline.draw();
    };

    return UDisplayReleasePhases;

  })();

  UDisplayReleaseProgressOverview = (function() {

    function UDisplayReleaseProgressOverview() {}

    UDisplayReleaseProgressOverview.prototype.execute = function(data) {
      var releases;
      releases = Release.createCollection(data);
      console.log(releases);
      this.viewModel = new ReleaseProgressViewmodel(releases);
      return ko.applyBindings(this.viewModel);
    };

    return UDisplayReleaseProgressOverview;

  })();

  UDisplayBurndown = (function() {

    function UDisplayBurndown(title, divName) {
      this.title = title;
      this.divName = divName;
    }

    UDisplayBurndown.prototype.execute = function(data) {
      var chart, graph, header, i, point, vals, _i, _j, _len, _len2, _ref, _ref2;
      console.log(this.title);
      $(this.divName).html('');
      header = this.title + ' - Velocity: ' + data.Velocity;
      chart = new Mnd.NumericChart(this.divName, 'Burndown Chart', header);
      i = 0;
      _ref = data.Graphs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        graph = _ref[_i];
        vals = [];
        _ref2 = graph.Values;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          point = _ref2[_j];
          vals.push([point.X, point.Y]);
        }
        chart.addLineName(graph.Name);
        chart.addLineData(i, vals);
        i++;
      }
      return chart.draw();
    };

    return UDisplayBurndown;

  })();

  UDisplayReleaseProgress = (function() {

    function UDisplayReleaseProgress(releaseTitle, divName) {
      this.releaseTitle = releaseTitle;
      this.divName = divName;
      this.dates = [];
    }

    UDisplayReleaseProgress.prototype.execute = function(jsonData, options) {
      var amt, artefactStatuses, chart, date, div, i, k, k2, key, milestones, s, states, totalsPerDay, v, v2, value, _i, _len, _ref, _results,
        _this = this;
      $(this.divName).html('');
      milestones = jsonData.reduce(function(acc, x) {
        var artefacts, id;
        id = x.Milestone;
        if (!acc[id]) {
          artefacts = jsonData.reduce(function(acc, x) {
            var statusDate;
            if (x.Milestone === id) {
              if (!acc[x.Artefact]) acc[x.Artefact] = [];
              statusDate = new DatePlus(DateFormatter.createJsDateFromJson(x.StatusDate));
              acc[x.Artefact].push({
                statusDate: statusDate,
                hoursRemaining: x.HoursRemaining
              });
            }
            return acc;
          }, []);
          acc[id] = artefacts;
        }
        return acc;
      }, []);
      amt = 1;
      _results = [];
      for (k in milestones) {
        v = milestones[k];
        states = [];
        for (key in v) {
          value = v[key];
          totalsPerDay = value.reduce(function(acc, x) {
            var id;
            id = x.statusDate.dateString;
            if (!acc[id]) acc[id] = 0;
            acc[id] += x.hoursRemaining;
            return acc;
          }, []);
          states.push({
            artefact: key,
            statuses: totalsPerDay
          });
        }
        div = 'graph' + amt;
        chart = new Mnd.TimeChart(this.divName, this.releaseTitle, k);
        i = 0;
        for (_i = 0, _len = states.length; _i < _len; _i++) {
          s = states[_i];
          artefactStatuses = [];
          _ref = s.statuses;
          for (k2 in _ref) {
            v2 = _ref[k2];
            date = new DatePlus(DateFormatter.createFromString(k2));
            artefactStatuses.push([date.timeStamp(), v2]);
          }
          chart.addLineName(s.artefact);
          chart.addLineData(i, artefactStatuses);
          i++;
        }
        chart.draw();
        _results.push(amt++);
      }
      return _results;
    };

    return UDisplayReleaseProgress;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

  root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow;

  root.UDisplayPhases = UDisplayPhases;

  root.UDisplayEnvironments = UDisplayEnvironments;

  root.UDisplayAbsences = UDisplayAbsences;

  root.UDisplayPlanningOverview = UDisplayPlanningOverview;

  root.UDisplayResourcesAvailability = UDisplayResourcesAvailability;

  root.ULoadAdminReleases = ULoadAdminReleases;

  root.ULoadAdminProjects = ULoadAdminProjects;

  root.ULoadAdminMeetings = ULoadAdminMeetings;

  root.ULoadAdminResources = ULoadAdminResources;

  root.ULoadAdminDeliverables = ULoadAdminDeliverables;

  root.ULoadAdminActivities = ULoadAdminActivities;

  root.ULoadPlanResources = ULoadPlanResources;

  root.ULoadUpdateReleaseStatus = ULoadUpdateReleaseStatus;

  root.UModifyAssignment = UModifyAssignment;

  root.UDeleteAssignment = UDeleteAssignment;

  root.URefreshView = URefreshView;

  root.UDisplayAssignments = UDisplayAssignments;

  root.UDisplayReleaseOverview = UDisplayReleaseOverview;

  root.UDisplayReleaseTimeline = UDisplayReleaseTimeline;

  root.UDisplayReleasePlanningInTimeline = UDisplayReleasePlanningInTimeline;

  root.UDisplayReleaseProgress = UDisplayReleaseProgress;

  root.UDisplayReleaseProgressOverview = UDisplayReleaseProgressOverview;

  root.UDisplayPlanningForResource = UDisplayPlanningForResource;

  root.UUpdateScreen = UUpdateScreen;

  root.URescheduleMilestone = URescheduleMilestone;

  root.UReschedulePhase = UReschedulePhase;

  root.UUpdateDeliverableStatus = UUpdateDeliverableStatus;

  root.UDisplayBurndown = UDisplayBurndown;

  root.UCreateVisualCuesForGates = UCreateVisualCuesForGates;

  root.UCreateVisualCuesForAbsences = UCreateVisualCuesForAbsences;

}).call(this);
