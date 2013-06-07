(function() {
  var EnvironmentsPlanningViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  EnvironmentsPlanningViewmodel = (function() {

    function EnvironmentsPlanningViewmodel(environments, versions) {
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.createVisualCuesForGates = __bind(this.createVisualCuesForGates, this);
      this.closeDetails = __bind(this.closeDetails, this);
      this.setAssignments = __bind(this.setAssignments, this);
      this.newAssignment = __bind(this.newAssignment, this);
      var updateScreenFunctions,
        _this = this;
      this.selectedPhase = ko.observable();
      this.selectedAssignment = ko.observable();
      this.selectedEnvironment = ko.observable();
      this.selectedVersion = ko.observable();
      this.selectedTimelineItem = ko.observable();
      this.selectedMilestone = ko.observable();
      this.assignments = ko.observableArray();
      this.selectedPhase.subscribe(function(newValue) {
        return loadAssignments(newValue.id);
      });
      this.environments = ko.observableArray(environments);
      this.versions = ko.observableArray(versions);
      this.selectedTimelineItem.subscribe(function(newValue) {
        console.log("selected timeline item");
        console.log(newValue.dataObject);
        console.log(_this.selectedAssignment());
        return _this.selectedAssignment(newValue.dataObject);
      });
      this.selectedAssignment.subscribe(function(newValue) {
        return console.log(newValue);
      });
      updateScreenFunctions = [];
      this.updateScreenUseCase = new UUpdateScreen(null, updateScreenFunctions);
    }

    EnvironmentsPlanningViewmodel.prototype.newAssignment = function() {
      var newAss;
      console.log("new assignment");
      newAss = {
        id: 0,
        phase: new Period(new Date(), new Date(), 'New Assignment', 0)
      };
      this.selectedAssignment(newAss);
      return console.log(this.selectedAssignment());
    };

    EnvironmentsPlanningViewmodel.prototype.setAssignments = function(jsonData) {
      this.assignments.removeAll();
      return this.assignments(AssignedResource.createCollection(jsonData));
    };

    EnvironmentsPlanningViewmodel.prototype.loadAssignments = function(releaseId) {
      var ajax;
      ajax = new Ajax();
      return ajax.getAssignedResourcesForRelease(releaseId, this.setAssignments);
    };

    EnvironmentsPlanningViewmodel.prototype.closeDetails = function() {
      return this.canShowDetails(false);
    };

    EnvironmentsPlanningViewmodel.prototype.createVisualCuesForGates = function(data) {
      var uc,
        _this = this;
      uc = new UCreateVisualCuesForGates(30, function(data) {
        return console.log('callback succesful: ' + data);
      });
      return uc.execute();
    };

    EnvironmentsPlanningViewmodel.prototype.selectPhase = function(data) {
      this.selectedPhase(data);
      return this.canShowDetails(true);
    };

    EnvironmentsPlanningViewmodel.prototype.saveSelectedAssignment = function() {};

    EnvironmentsPlanningViewmodel.prototype.deleteSelectedAssignment = function() {};

    return EnvironmentsPlanningViewmodel;

  })();

  root.EnvironmentsPlanningViewmodel = EnvironmentsPlanningViewmodel;

}).call(this);
