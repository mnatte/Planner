(function() {
  var PlanResourcesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PlanResourcesViewmodel = (function() {

    function PlanResourcesViewmodel(allReleases, allResources) {
      this.saveAssignment = __bind(this.saveAssignment, this);
      this.closeForm = __bind(this.closeForm, this);
      this.setAssignments = __bind(this.setAssignments, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectProject = __bind(this.selectProject, this);
      this.selectRelease = __bind(this.selectRelease, this);      AssignedResource.extend(RCrud);
      this.selectedProject = ko.observable();
      this.selectedRelease = ko.observable();
      this.selectedPhase = ko.observable();
      this.selectedResource = ko.observable();
      this.newAssignment = new AssignedResource(0, "", "", "", "", "", "", "", "", 0.8);
      this.allReleases = ko.observableArray(allReleases);
      this.allResources = ko.observableArray(allResources);
      this.assignments = ko.observableArray();
      this.canShowForm = ko.observable(false);
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

    PlanResourcesViewmodel.prototype.setAssignments = function(jsonData) {
      this.assignments.removeAll();
      return this.assignments(AssignedResource.createCollection(jsonData));
    };

    PlanResourcesViewmodel.prototype.loadAssignments = function() {
      var ajax;
      ajax = new Ajax();
      return ajax.getAssignedResources(this.selectedRelease().id, this.selectedProject().id, this.setAssignments);
    };

    PlanResourcesViewmodel.prototype.addResource = function() {
      return this.canShowForm(true);
    };

    PlanResourcesViewmodel.prototype.closeForm = function() {
      return this.canShowForm(false);
    };

    PlanResourcesViewmodel.prototype.saveAssignment = function() {
      var _this = this;
      this.newAssignment.phase = this.selectedRelease();
      this.newAssignment.resource = this.selectedResource();
      this.newAssignment.project = this.selectedProject();
      return this.newAssignment.save("/planner/ResourceAssignment/Save", ko.toJSON(this.newAssignment), function(data) {
        return console.log(data);
      });
    };

    return PlanResourcesViewmodel;

  })();

  root.PlanResourcesViewmodel = PlanResourcesViewmodel;

}).call(this);
