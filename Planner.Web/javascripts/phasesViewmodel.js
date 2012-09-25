(function() {
  var PhasesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PhasesViewmodel = (function() {

    function PhasesViewmodel(allReleases) {
      this.selectPhase = __bind(this.selectPhase, this);
      this.closeDetails = __bind(this.closeDetails, this);      this.selectedPhase = ko.observable();
      this.canShowDetails = ko.observable(false);
      Project.extend(RGroupBy);
    }

    PhasesViewmodel.prototype.load = function(data) {
      var activ, acts, del, descr, flatten, ms, obj, ph, pr, rel, remainingHours, work, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _len6, _m, _n, _ref, _ref2, _ref3, _ref4, _ref5;
      this.releases = [];
      this.displayData = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        rel = data[_i];
        console.log(rel.title + ': ' + rel.endDate.dateString);
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
          descr = '<ul>';
          _ref3 = ms.deliverables;
          for (_l = 0, _len4 = _ref3.length; _l < _len4; _l++) {
            del = _ref3[_l];
            flatten = [];
            descr += '<li>' + del.title + '</li>';
            _ref4 = del.scope;
            for (_m = 0, _len5 = _ref4.length; _m < _len5; _m++) {
              pr = _ref4[_m];
              _ref5 = pr.workload;
              for (_n = 0, _len6 = _ref5.length; _n < _len6; _n++) {
                work = _ref5[_n];
                flatten.push({
                  act: work.activity.title,
                  hrs: work.workload
                });
              }
              acts = pr.group('act', flatten);
              remainingHours = ((function() {
                var _len7, _o, _results;
                _results = [];
                for (_o = 0, _len7 = acts.length; _o < _len7; _o++) {
                  activ = acts[_o];
                  _results.push(activ.hrs);
                }
                return _results;
              })()).reduce(function(acc, x) {
                return acc + x;
              });
              console.log(acts);
            }
          }
          descr += '</ul>';
          obj = {
            group: rel.title,
            start: ms.date.date,
            content: ms.title + '<br /><span class="icon icon-milestone" />',
            info: ms.date.dateString + '<br />' + ms.description + '<br/>' + descr
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

    PhasesViewmodel.prototype.selectPhase = function(data) {
      this.selectedPhase(data);
      return this.canShowDetails(true);
    };

    return PhasesViewmodel;

  })();

  root.PhasesViewmodel = PhasesViewmodel;

}).call(this);
