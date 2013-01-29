(function() {
  var UDeleteResourceAssignment, UDisplayAbsences, UDisplayAssignments, UDisplayPhases, UDisplayPlanningOverview, UDisplayReleaseOverview, UDisplayReleasePhases, UDisplayReleasePlanningInTimeline, UDisplayReleaseStatus, UDisplayReleaseTimeline, UDisplayResourcesAvailability, UGetAvailableHoursForTeamMemberFromNow, ULoadAdminActivities, ULoadAdminDeliverables, ULoadAdminProjects, ULoadAdminReleases, ULoadAdminResources, ULoadPlanResources, ULoadUpdateReleaseStatus, UModifyResourceAssignment, URefreshView, URefreshViewAfterCheckPeriod, UReloadAbsenceInTimeline, root;

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
      timeline = new Mnd.Timeline(this.viewModel.showPhases);
      return timeline.draw();
    };

    return UDisplayPhases;

  })();

  UDisplayAbsences = (function() {

    function UDisplayAbsences() {}

    UDisplayAbsences.prototype.execute = function(data) {
      var resources, timeline;
      resources = Resource.createCollection(data);
      this.viewModel = new AbsencesViewmodel(resources);
      this.viewModel.load(resources.sort());
      ko.applyBindings(this.viewModel);
      timeline = new Mnd.Timeline(this.viewModel.showAbsences, this.viewModel.selectedTimelineItem);
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

  UModifyResourceAssignment = (function() {

    function UModifyResourceAssignment(assignment, updateViewUsecase) {
      this.assignment = assignment;
      this.updateViewUsecase = updateViewUsecase;
    }

    UModifyResourceAssignment.prototype.execute = function() {
      var json, serialized,
        _this = this;
      console.log('execute use case');
      serialized = this.assignment.toFlatJSON();
      json = ko.toJSON(serialized);
      console.log(json);
      return this.assignment.save("/planner/Resource/Assignments/Save", json, function(data) {
        return _this.refreshData(data);
      });
    };

    UModifyResourceAssignment.prototype.refreshData = function(resourceData) {
      var newResource;
      newResource = Resource.create(resourceData);
      this.updateViewUsecase.newResource = newResource;
      return this.updateViewUsecase.execute();
    };

    return UModifyResourceAssignment;

  })();

  UDeleteResourceAssignment = (function() {

    function UDeleteResourceAssignment(assignment, updateViewUsecase) {
      this.assignment = assignment;
      this.updateViewUsecase = updateViewUsecase;
    }

    UDeleteResourceAssignment.prototype.execute = function() {
      var json, serialized,
        _this = this;
      console.log('execute use case');
      serialized = this.assignment.toFlatJSON();
      json = ko.toJSON(serialized);
      console.log(json);
      return this.assignment.save("/planner/Resource/Assignments/Delete", json, function(data) {
        return _this.refreshData(data);
      });
    };

    UDeleteResourceAssignment.prototype.refreshData = function(resourceData) {
      var newResource;
      newResource = Resource.create(resourceData);
      this.updateViewUsecase.newResource = newResource;
      return this.updateViewUsecase.execute();
    };

    return UDeleteResourceAssignment;

  })();

  URefreshView = (function() {

    function URefreshView(viewModelObservableCollection, newResource, checkPeriod, viewModelObservableGraph, viewModelObservableForm) {
      this.viewModelObservableCollection = viewModelObservableCollection;
      this.newResource = newResource;
      this.checkPeriod = checkPeriod;
      this.viewModelObservableGraph = viewModelObservableGraph;
      this.viewModelObservableForm = viewModelObservableForm;
    }

    URefreshView.prototype.execute = function() {
      var a, index, oldResource, r, resWithAssAndAbsInDate, _i, _len, _ref;
      _ref = this.viewModelObservableCollection();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        r = _ref[_i];
        if (r.id === this.newResource.id) oldResource = r;
      }
      index = this.viewModelObservableCollection().indexOf(oldResource);
      resWithAssAndAbsInDate = this.newResource;
      resWithAssAndAbsInDate.assignments = (function() {
        var _j, _len2, _ref2, _results;
        _ref2 = this.newResource.assignments;
        _results = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          a = _ref2[_j];
          if (a.period.overlaps(this.checkPeriod)) _results.push(a);
        }
        return _results;
      }).call(this);
      resWithAssAndAbsInDate.periodsAway = (function() {
        var _j, _len2, _ref2, _results;
        _ref2 = this.newResource.periodsAway;
        _results = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          a = _ref2[_j];
          if (a.overlaps(this.checkPeriod)) _results.push(a);
        }
        return _results;
      }).call(this);
      this.viewModelObservableGraph(resWithAssAndAbsInDate);
      this.viewModelObservableForm(null);
      return this.viewModelObservableCollection.splice(index, 1, this.newResource);
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

  UDisplayReleaseOverview = (function() {

    function UDisplayReleaseOverview() {}

    UDisplayReleaseOverview.prototype.execute = function(data) {
      var releases;
      releases = Release.createCollection(data);
      console.log(releases);
      this.viewModel = new ReleaseOverviewViewmodel(releases);
      return ko.applyBindings(this.viewModel);
    };

    return UDisplayReleaseOverview;

  })();

  UDisplayReleaseTimeline = (function() {

    function UDisplayReleaseTimeline(release, observableTimelineSource) {
      this.release = release;
      this.observableTimelineSource = observableTimelineSource;
    }

    UDisplayReleaseTimeline.prototype.execute = function() {
      var act, activities, del, descr, icon, ms, obj, ph, proj, showData, style, timeline, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4;
      this.displayData = [];
      console.log('execute use case UDisplayReleaseTimeline');
      _ref = this.release.phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ph = _ref[_i];
        obj = {
          group: this.release.title,
          start: ph.startDate.date,
          end: ph.endDate.date,
          content: ph.title,
          info: ph.toString()
        };
        this.displayData.push(obj);
      }
      _ref2 = this.release.milestones;
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
                  return acc + x.availableHours();
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
        obj = {
          group: this.release.title,
          start: ms.date.date,
          content: ms.title + '<br />' + icon,
          info: ms.date.dateString + ' - ' + ms.time + '<br />' + descr
        };
        this.displayData.push(obj);
      }
      showData = this.displayData.sort(function(a, b) {
        return a.start - b.end;
      });
      console.log(showData);
      timeline = new Mnd.Timeline(showData, void 0, "100%", "200px", "mytimeline", "details");
      return timeline.draw();
    };

    return UDisplayReleaseTimeline;

  })();

  UDisplayReleasePlanningInTimeline = (function() {

    function UDisplayReleasePlanningInTimeline(release, observableTimelineSource) {
      this.release = release;
      this.observableTimelineSource = observableTimelineSource;
      this.trackAssignments = [];
    }

    UDisplayReleasePlanningInTimeline.prototype.execute = function() {
      var activity, assignment, del, dto, ms, obj, proj, releaseTitle, resource, showData, timeline, uniqueAsses, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4, _ref5;
      this.displayData = [];
      releaseTitle = this.release.title;
      console.log('execute use case UDisplayReleasePlanningInTimeline');
      console.log(this.release);
      uniqueAsses = [];
      _ref = this.release.milestones;
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
                  start: assignment.assignedPeriod.startDate.date,
                  end: assignment.assignedPeriod.endDate.date,
                  content: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.project.title,
                  info: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.assignedPeriod.toString(),
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
      timeline = new Mnd.Timeline(showData, void 0, "100%", "500px", "resourcePlanning", "assignmentDetails");
      return timeline.draw();
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

  root.UModifyResourceAssignment = UModifyResourceAssignment;

  root.UDeleteResourceAssignment = UDeleteResourceAssignment;

  root.URefreshView = URefreshView;

  root.UDisplayAssignments = UDisplayAssignments;

  root.UDisplayReleaseOverview = UDisplayReleaseOverview;

  root.UDisplayReleaseTimeline = UDisplayReleaseTimeline;

  root.UDisplayReleasePlanningInTimeline = UDisplayReleasePlanningInTimeline;

}).call(this);
