(function() {
  var ReleaseOverviewViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseOverviewViewmodel = (function() {

    function ReleaseOverviewViewmodel(allReleases) {
      var _this = this;
      this.allReleases = allReleases;
      this.viewReleasePlanning = __bind(this.viewReleasePlanning, this);
      this.inspectRelease = ko.observable();
      this.canShowDetails = ko.observable(false);
      this.assignments = ko.observableArray();
      this.inspectRelease.subscribe(function(newValue) {
        return console.log(newValue);
      });
      Resource.extend(RTeamMember);
    }

    ReleaseOverviewViewmodel.prototype.viewReleasePlanning = function(selectedRelease) {
      var uc, uc2;
      console.log(selectedRelease);
      this.inspectRelease(selectedRelease);
      uc = new UDisplayReleaseTimeline(selectedRelease);
      uc.execute();
      uc2 = new UDisplayReleasePlanningInTimeline(selectedRelease);
      return uc2.execute();
    };

    return ReleaseOverviewViewmodel;

  })();

  root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel;

}).call(this);
