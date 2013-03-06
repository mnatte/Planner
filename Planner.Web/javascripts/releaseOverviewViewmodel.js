(function() {
  var ReleaseOverviewViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseOverviewViewmodel = (function() {

    function ReleaseOverviewViewmodel(allReleases, allResources, allActivities) {
      var updateScreenUseCases,
        _this = this;
      this.allResources = allResources;
      this.allActivities = allActivities;
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveNewAssignment = __bind(this.saveNewAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.viewReleasePlanning = __bind(this.viewReleasePlanning, this);
      this.inspectRelease = ko.observable();
      this.selectedMilestone = ko.observable();
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
      this.selectedMilestone.subscribe(function(newValue) {
        var del, deliverables, ms, x, _i, _len, _ref;
        console.log(newValue);
        ms = newValue.dataObject;
        deliverables = [];
        console.log(newValue);
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
          resource: _this.selectedResource,
          deliverable: _this.selectedDeliverable,
          activity: _this.selectedActivity
        };
        return _this.newAssignment(x);
      });
      this.selectedTimelineItem = ko.observable();
      this.selectedAssignment = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        var x;
        console.log(newValue);
        x = newValue.dataObject;
        x.resourceName = newValue.dataObject.resource.fullName();
        x.resourceId = newValue.dataObject.resource.id;
        console.log(x);
        return _this.selectedAssignment(x);
      });
      updateScreenUseCases = [];
      updateScreenUseCases.push(new UDisplayReleaseTimeline(this.inspectRelease, this.selectedMilestone));
      updateScreenUseCases.push(new UDisplayReleasePlanningInTimeline(this.inspectRelease, this.selectedTimelineItem));
      this.updateScreenUseCase = new UUpdateScreen(updateScreenUseCases);
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
      useCase = new UModifyAssignment(this.selectedAssignment(), this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.selectedAssignment);
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.saveNewAssignment = function() {
      var ms, res, useCase, x;
      res = new Resource(this.selectedResource().id, this.selectedResource().firstName, this.selectedResource().middleName, this.selectedResource().lastName);
      ms = {
        id: this.newAssignment().milestone.id,
        title: this.newAssignment().milestone.title
      };
      x = this.newAssignment();
      x.resource = res;
      x.milestone = ms;
      x.project = this.selectedProject();
      x.activity = this.selectedActivity();
      x.deliverable = this.selectedDeliverable();
      useCase = new UModifyAssignment(x, this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.newAssignment);
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.deleteSelectedAssignment = function() {
      var useCase;
      useCase = new UDeleteResourceAssignment(this.selectedAssignment(), this.allReleases, this.inspectRelease, this.updateScreenUseCase, this.selectedAssignment);
      return useCase.execute();
    };

    return ReleaseOverviewViewmodel;

  })();

  root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel;

}).call(this);
