(function() {
  var PlanResourcesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PlanResourcesViewmodel = (function(_super) {

    __extends(PlanResourcesViewmodel, _super);

    function PlanResourcesViewmodel(allReleases, allResources, allActivities) {
      this.openDetailsWindow = __bind(this.openDetailsWindow, this);
      this.saveAssignments = __bind(this.saveAssignments, this);
      this.closeForm = __bind(this.closeForm, this);
      this.removeAssignment = __bind(this.removeAssignment, this);
      this.addAssignment = __bind(this.addAssignment, this);
      this.availableResources = __bind(this.availableResources, this);
      this.setAssignments = __bind(this.setAssignments, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectProject = __bind(this.selectProject, this);
      this.selectRelease = __bind(this.selectRelease, this);
      var _this = this;
      AssignedResource.extend(RAssignedResourceSerialize);
      ReleaseAssignments.extend(RCrud);
      PlanResourcesViewmodel.extend(RGroupBy);
      this.selectedProject = ko.observable();
      this.selectedRelease = ko.observable();
      this.selectedPhase = ko.observable();
      this.selectedMilestone = ko.observable();
      this.selectedDeliverable = ko.observable();
      this.selectedResource = ko.observable();
      this.selectedActivity = ko.observable();
      this.assignedStartDate = ko.observable();
      this.assignedEndDate = ko.observable();
      this.selectedMilestone.subscribe(function(newValue) {
        if (typeof newValue !== "undefined" && newValue !== null) {
          _this.newAssignment(new AssignedResource(0, "", "", "", 0.8, new Date(), newValue.date.date, "", new Milestone(), new Deliverable()));
          return console.log(_this.newAssignment());
        }
      });
      this.setEndDate = ko.observable(new Date());
      this.newAssignment = ko.observable(new AssignedResource(0, "", "", "", 0.8, new Date(), new Date(), "", new Milestone(), new Deliverable()));
      this.allReleases = ko.observableArray(allReleases);
      this.allResources = ko.observableArray(allResources);
      this.assignments = ko.observableArray();
      this.canShowForm = ko.observable(false);
      this.allActivities = allActivities;
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
      return this.assignments(AssignedResource.createCollection(jsonData, this.selectedProject(), this.selectedRelease()));
    };

    PlanResourcesViewmodel.prototype.loadAssignments = function() {
      var ajax;
      ajax = new Ajax();
      return ajax.getAssignedResources(this.selectedRelease().id, this.selectedProject().id, this.setAssignments);
    };

    PlanResourcesViewmodel.prototype.addResource = function() {
      return this.canShowForm(true);
    };

    PlanResourcesViewmodel.prototype.availableResources = function() {
      var a, assigned, available, res, _i, _len, _ref;
      assigned = [];
      _ref = this.assignments();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        a = _ref[_i];
        assigned.push(a.resource.id);
      }
      available = (function() {
        var _j, _len2, _ref2, _ref3, _results;
        _ref2 = this.allResources();
        _results = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          res = _ref2[_j];
          if (_ref3 = res.id, __indexOf.call(assigned, _ref3) < 0) {
            _results.push(res);
          }
        }
        return _results;
      }).call(this);
      return available;
    };

    PlanResourcesViewmodel.prototype.addAssignment = function() {
      var ass;
      console.log("addAssignment");
      console.log(this.newAssignment().assignedPeriod.startDate);
      console.log(this.newAssignment().assignedPeriod.endDate.dateString);
      console.log(this.newAssignment().assignedPeriod.endDate.date);
      ass = new AssignedResource(0, this.selectedRelease(), this.selectedResource(), this.selectedProject(), this.newAssignment().focusFactor, DateFormatter.createFromString(this.newAssignment().assignedPeriod.startDate.dateString), DateFormatter.createFromString(this.newAssignment().assignedPeriod.endDate.dateString), this.selectedActivity(), this.selectedMilestone(), this.selectedDeliverable());
      console.log(ass);
      this.assignments.push(ass);
      return this.canShowForm(false);
    };

    PlanResourcesViewmodel.prototype.removeAssignment = function(ass) {
      return this.assignments.remove(ass);
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

    PlanResourcesViewmodel.prototype.openDetailsWindow = function(model) {
      return window.open("Release.htm?RelId=" + (this.selectedRelease().id));
    };

    return PlanResourcesViewmodel;

  })(Mixin);

  root.PlanResourcesViewmodel = PlanResourcesViewmodel;

}).call(this);
