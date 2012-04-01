(function() {
  var PhasesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PhasesViewmodel = (function() {

    function PhasesViewmodel() {
      this.selectPhase = __bind(this.selectPhase, this);      this.selectedPhase = ko.observable();
    }

    PhasesViewmodel.prototype.load = function(data) {
      var abs, absence, phase, release, rl, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3,
        _this = this;
      this.releases = [];
      _ref = data.Releases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        release = _ref[_i];
        rl = new Release(DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title);
        _ref2 = release.Phases;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          phase = _ref2[_j];
          rl.addPhase(new Phase(DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title));
        }
        this.releases.push(rl);
      }
      this.absences = [];
      _ref3 = data.Absences;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        absence = _ref3[_k];
        abs = new Absence(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Person);
        this.absences.push(abs);
      }
      this.overlappingAbsences = ko.computed(function() {
        var a, abs, _l, _len4, _ref4;
        a = [];
        _ref4 = _this.absences;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          abs = _ref4[_l];
          if (!(abs.overlaps(_this.selectedPhase()))) continue;
          console.log("overlaps: " + abs);
          a.push(abs);
        }
        return a;
      }, this);
      return console.log("this.absences: " + this.absences);
    };

    PhasesViewmodel.prototype.currentPhases = function() {
      var current, phase, _i, _len, _ref;
      current = [];
      _ref = this.releases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        if (phase.isCurrent()) current.push(phase);
      }
      return current;
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
      console.log("selectPhase - function");
      this.selectedPhase(data);
      return console.log("selectPhase after selection: " + this.selectedPhase());
    };

    return PhasesViewmodel;

  })();

  root.PhasesViewmodel = PhasesViewmodel;

}).call(this);
