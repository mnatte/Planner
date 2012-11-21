(function() {
  var ResourceAvailabilityViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ResourceAvailabilityViewmodel = (function() {

    function ResourceAvailabilityViewmodel(allResources) {
      var monthLater,
        _this = this;
      this.allResources = allResources;
      this.inspectOverplanning = __bind(this.inspectOverplanning, this);
      this.checkAvailability = __bind(this.checkAvailability, this);
      Resource.extend(RTeamMember);
      this.includeResources = ko.observableArray();
      this.inspectResource = ko.observable();
      this.showCheckboxes = ko.observable(true);
      monthLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 30);
      this.checkPeriod = ko.observable(new Period(new Date(), monthLater));
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

    return ResourceAvailabilityViewmodel;

  })();

  root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel;

}).call(this);
