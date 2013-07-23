(function() {
  var EnvironmentsPlanningViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  EnvironmentsPlanningViewmodel = (function() {

    function EnvironmentsPlanningViewmodel(environments, versions) {
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.dehydrateEnvironment = __bind(this.dehydrateEnvironment, this);
      this.createVisualCuesForDates = __bind(this.createVisualCuesForDates, this);
      this.setAssignments = __bind(this.setAssignments, this);
      this.newAssignment = __bind(this.newAssignment, this);
      var updateScreenFunctions, updateScreenUseCases,
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
      updateScreenUseCases = [];
      updateScreenUseCases.push(new UDisplayEnvironmentsGraph(this.environments(), this.selectedTimelineItem));
      updateScreenFunctions.push(function() {
        return _this.selectedAssignment(null);
      });
      updateScreenFunctions.push(function() {
        return _this.selectedVersion(null);
      });
      updateScreenFunctions.push(function() {
        return _this.selectedEnvironment(null);
      });
      this.updateScreenUseCase = new UUpdateScreen(updateScreenUseCases, updateScreenFunctions);
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

    EnvironmentsPlanningViewmodel.prototype.createVisualCuesForDates = function(data) {};

    EnvironmentsPlanningViewmodel.prototype.dehydrateEnvironment = function(json) {
      var env;
      return env = Environment.create(json);
    };

    EnvironmentsPlanningViewmodel.prototype.saveSelectedAssignment = function() {
      var useCase;
      console.log("saveSelectedAssignment");
      useCase = new UPlanEnvironment(this.selectedEnvironment(), this.selectedVersion(), this.selectedAssignment().phase, this.environments, null, this.updateScreenUseCase, null, this.dehydrateEnvironment);
      useCase.execute();
      console.log(this.selectedAssignment());
      console.log(this.selectedEnvironment());
      return console.log(this.selectedVersion());
    };

    EnvironmentsPlanningViewmodel.prototype.deleteSelectedAssignment = function() {
      var useCase;
      console.log("deleteSelectedAssignment");
      useCase = new UUnAssignEnvironment(this.selectedEnvironment(), this.selectedVersion(), this.selectedAssignment().phase, this.environments, null, this.updateScreenUseCase, null, this.dehydrateEnvironment);
      return useCase.execute();
    };

    return EnvironmentsPlanningViewmodel;

  })();

  root.EnvironmentsPlanningViewmodel = EnvironmentsPlanningViewmodel;

}).call(this);
