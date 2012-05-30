(function() {
  var PlanResourcesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PlanResourcesViewmodel = (function() {

    function PlanResourcesViewmodel(allReleases, allProjects) {
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectProject = __bind(this.selectProject, this);
      this.selectRelease = __bind(this.selectRelease, this);      this.selectedProject = ko.observable();
      this.selectedRelease = ko.observable();
      this.selectedPhase = ko.observable();
      this.allReleases = ko.observableArray(allReleases);
      this.allProjects = ko.observableArray(allProjects);
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
    }

    PlanResourcesViewmodel.prototype.selectRelease = function(data) {
      return this.selectedRelease(data);
    };

    PlanResourcesViewmodel.prototype.selectProject = function(data) {
      return this.selectedProject(data);
    };

    PlanResourcesViewmodel.prototype.selectPhase = function(data) {
      return this.selectedPhase(data);
    };

    return PlanResourcesViewmodel;

  })();

  root.PlanResourcesViewmodel = PlanResourcesViewmodel;

}).call(this);
