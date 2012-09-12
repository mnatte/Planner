(function() {
  var PhasesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PhasesViewmodel = (function() {

    function PhasesViewmodel(allReleases) {
      this.selectPhase = __bind(this.selectPhase, this);
      this.closeDetails = __bind(this.closeDetails, this);
      var endDate, startDate;
      this.selectedPhase = ko.observable();
      this.canShowDetails = ko.observable(false);
      this.centerDate = ko.observable(new Date());
      this.currentPhases = ko.observableArray();
      startDate = new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14));
      endDate = new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28));
      this.periodToView = ko.observable(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
    }

    PhasesViewmodel.prototype.load = function(data) {
      var ms, obj, ph, rel, _i, _j, _k, _len, _len2, _len3, _ref, _ref2;
      this.releases = [];
      this.displayData = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        rel = data[_i];
        console.log(rel.title + ': ' + rel.endDate.dateString);
        this.currentPhases.push(rel);
        _ref = rel.phases;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          ph = _ref[_j];
          obj = {
            group: rel.title,
            start: ph.startDate.date,
            end: ph.endDate.date,
            content: ph.title,
            info: ph.toString()
          };
          this.displayData.push(obj);
        }
        _ref2 = rel.milestones;
        for (_k = 0, _len3 = _ref2.length; _k < _len3; _k++) {
          ms = _ref2[_k];
          obj = {
            group: rel.title,
            start: ms.date.date,
            content: ms.title + '<br /><span class="icon icon-milestone" />',
            info: ms.date.dateString + '<br />' + ms.description
          };
          this.displayData.push(obj);
        }
      }
      return this.showPhases = this.displayData.sort(function(a, b) {
        if (a.end > b.end) {
          return 1;
        } else if (a.end < b.end) {
          return -1;
        } else {
          return 0;
        }
      });
    };

    PhasesViewmodel.prototype.closeDetails = function() {
      return this.canShowDetails(false);
    };

    PhasesViewmodel.prototype.nextViewPeriod = function() {
      var phase, _i, _len, _ref, _results;
      this.centerDate(new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 49)));
      this.periodToView(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
      this.currentPhases.removeAll();
      _ref = this.releases;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        if (phase.overlaps(this.periodToView())) {
          _results.push(this.currentPhases.push(phase));
        }
      }
      return _results;
    };

    PhasesViewmodel.prototype.prevViewPeriod = function() {
      var phase, _i, _len, _ref, _results;
      this.centerDate(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 49)));
      this.periodToView(new Period(new Date(this.centerDate().getTime() - (24 * 60 * 60 * 1000 * 14)), new Date(this.centerDate().getTime() + (24 * 60 * 60 * 1000 * 28)), "View Period"));
      this.currentPhases.removeAll();
      _ref = this.releases;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        if (phase.overlaps(this.periodToView())) {
          _results.push(this.currentPhases.push(phase));
        }
      }
      return _results;
    };

    PhasesViewmodel.prototype.selectPhase = function(data) {
      this.selectedPhase(data);
      return this.canShowDetails(true);
    };

    return PhasesViewmodel;

  })();

  root.PhasesViewmodel = PhasesViewmodel;

}).call(this);
