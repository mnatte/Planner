(function() {
  var ReleaseOverviewViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseOverviewViewmodel = (function() {

    function ReleaseOverviewViewmodel(allReleases, allResources, allActivities) {
      var _this = this;
      this.allResources = allResources;
      this.allActivities = allActivities;
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveNewAssignment = __bind(this.saveNewAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.viewReleasePlanning = __bind(this.viewReleasePlanning, this);
      this.inspectRelease = ko.observable();
      this.selectedMilestone = ko.observable();
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
        var x;
        console.log(newValue);
        x = newValue.dataObject;
        x.releaseName = _this.inspectRelease().title;
        x.milestoneName = newValue.dataObject.title;
        x.period = new Period(new Date(), newValue.dataObject.date.date, "planned period");
        x.focusFactor = 0.8;
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
      Resource.extend(RTeamMember);
      Assignment.extend(RAssignmentSerialize);
      Assignment.extend(RCrud);
    }

    ReleaseOverviewViewmodel.prototype.viewReleasePlanning = function(selectedRelease) {
      var uc, uc2;
      console.log(selectedRelease);
      this.inspectRelease(selectedRelease);
      uc = new UDisplayReleaseTimeline(selectedRelease, this.selectedMilestone);
      uc.execute();
      uc2 = new UDisplayReleasePlanningInTimeline(this.inspectRelease, this.selectedTimelineItem);
      return uc2.execute();
    };

    ReleaseOverviewViewmodel.prototype.saveSelectedAssignment = function() {
      var updateUc, useCase;
      updateUc = new UDisplayReleasePlanningInTimeline(this.inspectRelease, this.selectedTimelineItem);
      useCase = new UModifyAssignment(this.selectedAssignment(), this.allReleases, this.inspectRelease, updateUc, this.selectedAssignment);
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.saveNewAssignment = function() {
      var updateUc, useCase;
      updateUc = new UDisplayReleasePlanningInTimeline(this.inspectRelease, this.selectedTimelineItem);
      useCase = new UModifyAssignment(this.newAssignment(), this.allReleases, this.inspectRelease, updateUc, this.newAssignment);
      return useCase.execute();
    };

    ReleaseOverviewViewmodel.prototype.deleteSelectedAssignment = function() {};

    return ReleaseOverviewViewmodel;

  })();

  root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel;

}).call(this);
