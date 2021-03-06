(function() {
  var ReleaseOverviewViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseOverviewViewmodel = (function() {

    function ReleaseOverviewViewmodel(allReleases, allResources, allActivities) {
      var updateScreenFunctions, updateScreenUseCases,
        _this = this;
      this.allResources = allResources;
      this.allActivities = allActivities;
      this.rescheduleSelectedPeriod = __bind(this.rescheduleSelectedPeriod, this);
      this.rescheduleSelectedMilestone = __bind(this.rescheduleSelectedMilestone, this);
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveNewAssignment = __bind(this.saveNewAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.viewReleasePlanning = __bind(this.viewReleasePlanning, this);
      this.inspectRelease = ko.observable();
      this.selectedTimelineItem = ko.observable();
      this.selectedReleaseTimelineItem = ko.observable();
      this.selectedMilestone = ko.observable();
      this.selectedPhase = ko.observable();
      this.selectedProject = ko.observable();
      this.newAssignment = ko.observable();
      this.canShowDetails = ko.observable(false);
      this.allReleases = ko.observableArray(allReleases);
      this.selectedResource = ko.observable();
      this.selectedDeliverable = ko.observable();
      this.selectedActivity = ko.observable();
      this.selectedResource.subscribe(function(newValue) {
        var uc;
        console.log(newValue);
        uc = new UDisplayPlanningForResource(newValue, _this.newAssignment().period);
        return uc.execute();
      });
      this.resourcesToAssign = ko.observableArray();
      this.resourcesToAssign.subscribe(function(newValue) {
        var include;
        console.log(newValue);
        include = newValue.reduce(function(acc, x) {
          var r, resource, _i, _len, _ref;
          _ref = _this.allResources;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            r = _ref[_i];
            if (+r.id === +x.id) resource = r;
          }
          acc.push(resource);
          return acc;
        }, []);
        return _this.resourcesInTimeline(include);
      });
      this.resourcesInTimeline = ko.observableArray();
      this.resourcesInTimeline.subscribe(function(newValue) {
        var uc;
        console.log(newValue);
        uc = new UDisplayPlanningForMultipleResources(newValue, _this.newAssignment().period);
        return uc.execute();
      });
      this.selectedReleaseTimelineItem.subscribe(function(newValue) {
        console.log(newValue);
        _this.selectedAssignment(null);
        if (newValue) {
          if (newValue.dataObject.deliverables) {
            return _this.selectedMilestone(newValue);
          } else {
            return _this.selectedPhase(newValue);
          }
        }
      });
      this.selectedPhase.subscribe(function(newValue) {
        if (newValue) {
          console.log(newValue);
          newValue.dataObject.release = {
            id: _this.inspectRelease().id,
            title: _this.inspectRelease().title
          };
          _this.newAssignment(null);
          return _this.selectedMilestone(null);
        }
      });
      this.selectedMilestone.subscribe(function(newValue) {
        var del, deliverables, ms, x, _i, _len, _ref;
        console.log(newValue);
        if (newValue) {
          ms = newValue.dataObject;
          deliverables = [];
          _ref = newValue.dataObject.deliverables;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            del = _ref[_i];
            deliverables.push({
              id: del.id,
              title: del.title,
              activities: del.activities
            });
          }
          ms.deliverables = deliverables;
          x = {
            id: 0,
            release: {
              id: _this.inspectRelease().id,
              title: _this.inspectRelease().title
            },
            focusFactor: 0.8,
            period: new Period(new Date(), newValue.dataObject.date.date, "new assignment"),
            milestone: ms,
            resources: _this.resourcesInTimeline,
            deliverable: _this.selectedDeliverable,
            activity: _this.selectedActivity
          };
        }
        _this.newAssignment(x);
        return _this.selectedPhase(null);
      });
      this.selectedAssignment = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        var x;
        console.log(newValue);
        if (newValue) {
          x = newValue.dataObject;
          if (x.type() === "Assignment") {
            x.resourceName = newValue.dataObject.resource.fullName();
            x.resourceId = newValue.dataObject.resource.id;
            console.log(x);
            return _this.selectedAssignment(x);
          }
        }
      });
      updateScreenUseCases = [];
      updateScreenFunctions = [];
      updateScreenUseCases.push(new UDisplayReleaseTimeline(this.inspectRelease, this.selectedReleaseTimelineItem));
      updateScreenUseCases.push(new UDisplayReleasePlanningInTimeline(this.inspectRelease, this.selectedTimelineItem, this.allResources));
      updateScreenFunctions.push(function() {
        return _this.selectedTimelineItem(null);
      });
      updateScreenFunctions.push(function() {
        return _this.selectedMilestone(null);
      });
      updateScreenFunctions.push(function() {
        return _this.selectedPhase(null);
      });
      this.updateScreenUseCase = new UUpdateScreen(updateScreenUseCases, updateScreenFunctions);
      Resource.extend(RTeamMember);
      Assignment.extend(RAssignmentSerialize);
      Assignment.extend(RCrud);
    }

    ReleaseOverviewViewmodel.prototype.viewReleasePlanning = function(selectedRelease) {
      console.log(selectedRelease);
      this.inspectRelease(selectedRelease);
      return this.updateScreenUseCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.saveSelectedAssignment = function() {
      var useCase;
      useCase = new UModifyAssignment(this.selectedAssignment(), this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.selectedAssignment, "release", function(json) {
        return Release.create(json);
      });
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.saveNewAssignment = function() {
      var ass, ms, useCase;
      ms = {
        id: this.newAssignment().milestone.id,
        title: this.newAssignment().milestone.title
      };
      ass = this.newAssignment();
      ass.resources = this.resourcesInTimeline();
      ass.milestone = ms;
      ass.project = this.selectedProject();
      ass.activity = this.selectedActivity();
      ass.deliverable = this.selectedDeliverable();
      console.log(ass);
      useCase = new UAddAssignments(ass, this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.newAssignment, "release", function(json) {
        return Release.create(json);
      });
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.deleteSelectedAssignment = function() {
      var useCase;
      useCase = new UDeleteAssignment(this.selectedAssignment(), this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.selectedAssignment, "release", function(json) {
        return Release.create(json);
      });
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.rescheduleSelectedMilestone = function() {
      var date, ms, uc;
      date = DateFormatter.createFromString(this.selectedMilestone().dataObject.date.dateString);
      ms = new Milestone(this.selectedMilestone().dataObject.id, date, this.selectedMilestone().dataObject.time, null, null, this.selectedMilestone().dataObject.release.id);
      uc = new URescheduleMilestone(ms, this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.selectedAssignment, function(json) {
        return Release.create(json);
      });
      return uc.execute();
    };

    ReleaseOverviewViewmodel.prototype.rescheduleSelectedPeriod = function() {
      var endDate, phase, startDate, uc;
      startDate = DateFormatter.createFromString(this.selectedPhase().dataObject.startDate.dateString);
      endDate = DateFormatter.createFromString(this.selectedPhase().dataObject.endDate.dateString);
      phase = new Phase(this.selectedPhase().dataObject.id, startDate, endDate, null, this.selectedPhase().dataObject.release.id);
      uc = new UReschedulePhase(phase, this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.selectedAssignment, function(json) {
        return Release.create(json);
      });
      return uc.execute();
    };

    return ReleaseOverviewViewmodel;

  })();

  root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel;

}).call(this);
