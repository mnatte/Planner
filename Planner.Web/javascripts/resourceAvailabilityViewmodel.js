(function() {
  var ResourceAvailabilityViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ResourceAvailabilityViewmodel = (function() {

    function ResourceAvailabilityViewmodel(allResources) {
      var monthLater,
        _this = this;
      this.allResources = allResources;
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      this.refreshData = __bind(this.refreshData, this);
      this.inspectOverplanning = __bind(this.inspectOverplanning, this);
      this.checkAvailability = __bind(this.checkAvailability, this);
      Resource.extend(RTeamMember);
      ResourceAssignment.extend(RResourceAssignmentSerialize);
      ResourceAssignment.extend(RCrud);
      this.includeResources = ko.observableArray();
      this.inspectResource = ko.observable();
      monthLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 30);
      this.checkPeriod = ko.observable(new Period(new Date(), monthLater));
      this.selectedTimelineItem = ko.observable();
      this.selectedAssignment = ko.observable();
      this.selectedResource = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        var aap;
        console.log(newValue);
        aap = newValue.assignment;
        aap.resourceName = newValue.resource.fullName();
        aap.resourceId = newValue.resource.id;
        console.log(newValue.assignment);
        return _this.selectedAssignment(newValue.assignment);
      });
      this.selectedAssignment.subscribe(function(newValue) {
        return console.log('selectedAssignment changed: ' + newValue);
      });
      this.checkPeriod.subscribe(function(newValue) {
        return _this.inspectResource();
      });
      this.totalHoursAvailable = ko.computed(function() {
        var res, total;
        total = ((function() {
          var _i, _len, _ref, _results;
          _ref = this.includeResources();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            res = _ref[_i];
            _results.push(res);
          }
          return _results;
        }).call(_this)).reduce(function(acc, x) {
          var r, resource, result, _i, _len, _ref;
          _ref = _this.allResources;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            r = _ref[_i];
            if (+r.id === +x) resource = r;
          }
          result = resource.availableHoursForPlanning(_this.checkPeriod());
          return acc + result;
        }, 0);
        return total;
      }, this);
    }

    ResourceAvailabilityViewmodel.prototype.checkAvailability = function(data) {
      var period;
      period = new Period(DateFormatter.createFromString(this.checkPeriod().startDate.dateString), DateFormatter.createFromString(this.checkPeriod().endDate.dateString));
      return this.checkPeriod(period);
    };

    ResourceAvailabilityViewmodel.prototype.inspectOverplanning = function(resource) {
      var a, resWithAssAndAbsInDate;
      console.log(resource);
      resWithAssAndAbsInDate = resource;
      resWithAssAndAbsInDate.assignments = (function() {
        var _i, _len, _ref, _results;
        _ref = resource.assignments;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.period.overlaps(this.checkPeriod())) _results.push(a);
        }
        return _results;
      }).call(this);
      resWithAssAndAbsInDate.periodsAway = (function() {
        var _i, _len, _ref, _results;
        _ref = resource.periodsAway;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.overlaps(this.checkPeriod())) _results.push(a);
        }
        return _results;
      }).call(this);
      return this.inspectResource(resWithAssAndAbsInDate);
    };

    ResourceAvailabilityViewmodel.prototype.refreshData = function(index, data) {
      console.log('refreshData');
      console.log(index);
      return console.log(data);
    };

    ResourceAvailabilityViewmodel.prototype.saveSelectedAssignment = function() {
      var useCase;
      useCase = new UModifyResourceAssignment(null, this.selectedAssignment(), this.checkPeriod(), this.inspectResource, this.selectedAssignment);
      return useCase.execute();
    };

    ResourceAvailabilityViewmodel.prototype.deleteSelectedAssignment = function() {
      return console.log(this.selectedAssignment());
    };

    return ResourceAvailabilityViewmodel;

  })();

  root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel;

}).call(this);
