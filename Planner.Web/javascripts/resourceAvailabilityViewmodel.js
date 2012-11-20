(function() {
  var ResourceAvailabilityViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ResourceAvailabilityViewmodel = (function() {

    function ResourceAvailabilityViewmodel(allResources) {
      var _this = this;
      this.allResources = allResources;
      this.checkAvailability = __bind(this.checkAvailability, this);
      Resource.extend(RTeamMember);
      this.includeResources = ko.observableArray();
      this.showCheckboxes = ko.observable(true);
      this.checkPeriod = ko.observable(new Period(new Date(), new Date()));
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

    return ResourceAvailabilityViewmodel;

  })();

  root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel;

}).call(this);
