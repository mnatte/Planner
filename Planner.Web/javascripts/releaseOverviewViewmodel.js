(function() {
  var ReleaseOverviewViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseOverviewViewmodel = (function() {

    function ReleaseOverviewViewmodel(allReleases) {
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.viewReleasePlanning = __bind(this.viewReleasePlanning, this);
      var _this = this;
      this.inspectRelease = ko.observable();
      this.canShowDetails = ko.observable(false);
      this.allReleases = ko.observableArray(allReleases);
      this.inspectRelease.subscribe(function(newValue) {
        return console.log(newValue);
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
      uc = new UDisplayReleaseTimeline(selectedRelease);
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

    ReleaseOverviewViewmodel.prototype.deleteSelectedAssignment = function() {};

    return ReleaseOverviewViewmodel;

  })();

  root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel;

}).call(this);
