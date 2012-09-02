(function() {
  var PlanningOverviewViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PlanningOverviewViewmodel = (function() {

    function PlanningOverviewViewmodel(allResources) {
      this.prevViewPeriod = __bind(this.prevViewPeriod, this);
      this.nextViewPeriod = __bind(this.nextViewPeriod, this);
      var endDate, startDate;
      this.allResources = ko.observableArray(allResources);
      this.selectedPhase = ko.observable();
      this.centerDate = ko.observable(new Date());
      startDate = new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14));
      endDate = new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28));
      this.periodToView = ko.observable(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
      console.log(this.periodToView());
    }

    PlanningOverviewViewmodel.prototype.load = function(data) {
      var abs, absence, phase, res, resource, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3, _ref4,
        _this = this;
      this.resources = [];
      _ref = data.Resources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        resource = _ref[_i];
        res = new Resource(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title);
        _ref2 = release.Phases;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          phase = _ref2[_j];
          rl.addPhase(new Phase(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title));
        }
        rl.phases.sort(function(a, b) {
          if (a.startDate.date > b.startDate.date) {
            return 1;
          } else if (a.startDate.date < b.startDate.date) {
            return -1;
          } else {
            return 0;
          }
        });
        this.releases.push(rl);
      }
      this.releases.sort(function(a, b) {
        if (a.startDate.date > b.startDate.date) {
          return 1;
        } else if (a.startDate.date < b.startDate.date) {
          return -1;
        } else {
          return 0;
        }
      });
      _ref3 = this.releases;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        phase = _ref3[_k];
        if (phase.overlaps(this.periodToView())) this.currentPhases.push(phase);
      }
      this.absences = [];
      _ref4 = data.Absences;
      for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
        absence = _ref4[_l];
        abs = new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Person);
        this.absences.push(abs);
      }
      return this.overlappingAbsences = ko.computed(function() {
        var a, abs, _len5, _m, _ref5;
        a = [];
        _ref5 = _this.absences;
        for (_m = 0, _len5 = _ref5.length; _m < _len5; _m++) {
          abs = _ref5[_m];
          if (abs.overlaps(_this.selectedPhase())) a.push(abs);
        }
        return a;
      }, this);
    };

    PlanningOverviewViewmodel.prototype.nextViewPeriod = function() {
      this.centerDate(new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 49)));
      return this.periodToView(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
    };

    PlanningOverviewViewmodel.prototype.prevViewPeriod = function() {
      this.centerDate(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 49)));
      return this.periodToView(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
    };

    PlanningOverviewViewmodel.prototype.currentAbsences = function() {
      var abs, current, _i, _len, _ref;
      current = [];
      _ref = this.absences;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        abs = _ref[_i];
        if (abs.isCurrent()) current.push(abs);
      }
      return current;
    };

    return PlanningOverviewViewmodel;

  })();

  root.PlanningOverviewViewmodel = PlanningOverviewViewmodel;

}).call(this);
