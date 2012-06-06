(function() {
  var PlanResourcesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PlanResourcesViewmodel = (function() {

    function PlanResourcesViewmodel(allReleases, allResources) {
      this.saveAssignments = __bind(this.saveAssignments, this);
      this.closeForm = __bind(this.closeForm, this);
      this.addAssignment = __bind(this.addAssignment, this);
      this.setAssignments = __bind(this.setAssignments, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectProject = __bind(this.selectProject, this);
      this.selectRelease = __bind(this.selectRelease, this);      ReleaseAssignments.extend(RCrud);
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

    PlanResourcesViewmodel.prototype.addAssignment = function() {
      return this.assignments.push(new AssignedResource(0, this.selectedRelease().id, "", this.selectedResource().id, this.selectedResource().firstName, this.selectedResource().middleName, this.selectedResource().lastName, this.selectedProject().id, "", this.newAssignment.focusFactor));
    };

    PlanResourcesViewmodel.prototype.closeForm = function() {
      return this.canShowForm(false);
    };

    PlanResourcesViewmodel.prototype.saveAssignments = function() {
      var dto,
        _this = this;
      dto = new ReleaseAssignments(this.selectedRelease().id, this.selectedProject().id, this.assignments());
      console.log(ko.toJSON(dto));
      return dto.save("/planner/ResourceAssignment/SaveAssignments", ko.toJSON(dto), function(data) {
        return console.log(data);
      });
    };

    return PlanResourcesViewmodel;

  })();

  root.PlanResourcesViewmodel = PlanResourcesViewmodel;

}).call(this);
