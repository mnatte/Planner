(function() {
  var CalculateNeededResourcesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  CalculateNeededResourcesViewmodel = (function() {

    function CalculateNeededResourcesViewmodel(deliverable, period, focusFactor) {
      var _this = this;
      this.deliverable = deliverable;
      this.datesChanged = __bind(this.datesChanged, this);
      this.calculateResourcesNeeded = __bind(this.calculateResourcesNeeded, this);
      console.log(deliverable);
      console.log(period);
      console.log(focusFactor);
      this.period = ko.observable(period);
      this.focusFactor = ko.observable();
      this.resourcesNeeded = ko.observable();
      this.focusFactor.subscribe(function(newValue) {
        console.log(newValue);
        return _this.resourcesNeeded(_this.calculateResourcesNeeded(_this.deliverable));
      });
      this.period.subscribe(function(newValue) {
        console.log(newValue);
        return _this.resourcesNeeded(_this.calculateResourcesNeeded(_this.deliverable));
      });
      this.focusFactor(focusFactor);
    }

    CalculateNeededResourcesViewmodel.prototype.calculateResourcesNeeded = function(deliverable) {
      var availableWorkingHours, effectiveResourceHoursPerDay, fteNeeded, hoursRemaining, hrs, sc, _i, _len, _ref,
        _this = this;
      if (deliverable && deliverable.scope) {
        hoursRemaining = 0;
        _ref = deliverable.scope;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          sc = _ref[_i];
          hrs = sc.workload.reduce(function(acc, x) {
            return acc + +x.hoursRemaining;
          }, 0);
          hoursRemaining += hrs;
        }
        effectiveResourceHoursPerDay = this.focusFactor() * 8;
        availableWorkingHours = this.period().remainingWorkingDays() * effectiveResourceHoursPerDay;
        fteNeeded = (hoursRemaining / availableWorkingHours).toFixed(2);
        return fteNeeded;
      }
    };

    CalculateNeededResourcesViewmodel.prototype.datesChanged = function(data) {
      var period;
      period = new Period(DateFormatter.createFromString(this.period().startDate.dateString), DateFormatter.createFromString(this.period().endDate.dateString));
      return this.period(period);
    };

    return CalculateNeededResourcesViewmodel;

  })();

  root.CalculateNeededResourcesViewmodel = CalculateNeededResourcesViewmodel;

}).call(this);
