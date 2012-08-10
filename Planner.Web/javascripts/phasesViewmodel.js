(function() {
  var PhasesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PhasesViewmodel = (function() {

    function PhasesViewmodel() {
      this.selectPhase = __bind(this.selectPhase, this);
      this.closeDetails = __bind(this.closeDetails, this);
      var endDate, startDate;
      this.selectedPhase = ko.observable();
      this.canShowDetails = ko.observable(false);
      this.centerDate = ko.observable(new Date());
      startDate = new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14));
      endDate = new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28));
      this.periodToView = ko.observable(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
      console.log(this.periodToView());
    }

    PhasesViewmodel.prototype.load = function(data) {
      var abs, absence, phase, release, rl, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3,
        _this = this;
      this.releases = [];
      _ref = data.Releases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        release = _ref[_i];
        rl = new Release(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title);
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
      this.absences = [];
      _ref3 = data.Absences;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        absence = _ref3[_k];
        abs = new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Person);
        this.absences.push(abs);
      }
      return this.overlappingAbsences = ko.computed(function() {
        var a, abs, _l, _len4, _ref4;
        a = [];
        _ref4 = _this.absences;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          abs = _ref4[_l];
          if (abs.overlaps(_this.selectedPhase())) a.push(abs);
        }
        return a;
      }, this);
    };

    PhasesViewmodel.prototype.currentPhases = function() {
      var current, phase, _i, _len, _ref;
      console.log("currentPhases");
      current = [];
      _ref = this.releases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        if (phase.overlaps(this.periodToView())) current.push(phase);
      }
      return current;
    };

    PhasesViewmodel.prototype.closeDetails = function() {
      return this.canShowDetails(false);
    };

    PhasesViewmodel.prototype.nextViewPeriod = function() {
      this.centerDate(new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 49)));
      console.log(this.centerDate());
      console.log(this.periodToView());
      this.periodToView(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
      return console.log(this.periodToView());
    };

    PhasesViewmodel.prototype.prevViewPeriod = function() {
      this.centerDate(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 49)));
      console.log(this.centerDate());
      console.log(this.periodToView());
      this.periodToView(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
      return console.log(this.periodToView());
    };

    PhasesViewmodel.prototype.currentAbsences = function() {
      var abs, current, _i, _len, _ref;
      current = [];
      _ref = this.absences;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        abs = _ref[_i];
        if (abs.isCurrent()) current.push(abs);
      }
      return current;
    };

    PhasesViewmodel.prototype.selectPhase = function(data) {
      this.selectedPhase(data);
      return this.canShowDetails(true);
    };

    return PhasesViewmodel;

  })();

  root.PhasesViewmodel = PhasesViewmodel;

}).call(this);
