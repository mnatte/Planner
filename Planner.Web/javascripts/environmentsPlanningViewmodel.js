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
      this.selectedAssignment = ko.observable();
      this.selectedEnvironment = ko.observable();
      this.selectedVersion = ko.observable();
      this.selectedTimelineItem = ko.observable();
      this.assignments = ko.observableArray();
      this.environments = ko.observableArray(environments);
      this.versions = ko.observableArray(versions);
      this.selectedTimelineItem.subscribe(function(newValue) {
        var environment, i, version, _i, _j, _len, _len2, _ref, _ref2;
        console.log("selected timeline item");
        console.log(newValue.dataObject);
        _this.selectedAssignment(newValue.dataObject);
        _ref = _this.versions();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          if (i.id === newValue.dataObject.version.id) version = i;
        }
        _ref2 = _this.environments();
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          i = _ref2[_j];
          if (i.id === newValue.dataObject.environmentId) environment = i;
        }
        _this.selectedVersion(version);
        return _this.selectedEnvironment(environment);
      });
      this.selectedAssignment.subscribe(function(newValue) {
        console.log("selected assignment");
        return console.log(newValue);
      });
      this.selectedVersion.subscribe(function(newValue) {
        console.log("selected version changed");
        return console.log(newValue);
      });
      this.selectedEnvironment.subscribe(function(newValue) {
        console.log("selected environment");
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
      console.log("setAssignments");
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
      console.log("createVisualCuesForGates");
      uc = new UCreateVisualCuesForGates(30, function(data) {
        return console.log('callback succesful: ' + data);
      });
      return uc.execute();
    };

    EnvironmentsPlanningViewmodel.prototype.selectPhase = function(data) {
      console.log("selectPhase");
      this.selectedPhase(data);
      return this.canShowDetails(true);
    };

    EnvironmentsPlanningViewmodel.prototype.saveSelectedAssignment = function() {
      var useCase;
      console.log("saveSelectedAssignment");
      useCase = new UPlanEnvironment(this.selectedEnvironment(), this.selectedVersion(), this.selectedAssignment().phase, this.environments(), this.selectedAssignment(), this.updateScreenUseCase, 'undefined', function(json) {
        return Release.create(json);
      });
      useCase.execute();
      console.log(this.selectedAssignment());
      console.log(this.selectedEnvironment());
      return console.log(this.selectedVersion());
    };

    EnvironmentsPlanningViewmodel.prototype.deleteSelectedAssignment = function() {
      var useCase;
      console.log("deleteSelectedAssignment");
      useCase = new UUnAssignEnvironment(this.selectedEnvironment(), this.selectedVersion(), this.selectedAssignment().phase, this.environments(), this.selectedAssignment(), this.updateScreenUseCase);
      return useCase.execute();
    };

    return EnvironmentsPlanningViewmodel;

  })();

  root.EnvironmentsPlanningViewmodel = EnvironmentsPlanningViewmodel;

}).call(this);