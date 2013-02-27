(function() {
  var PhasesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  PhasesViewmodel = (function() {

    function PhasesViewmodel(allReleases) {
      this.selectPhase = __bind(this.selectPhase, this);
      this.closeDetails = __bind(this.closeDetails, this);
      this.setAssignments = __bind(this.setAssignments, this);
      var _this = this;
      this.selectedPhase = ko.observable();
      this.canShowDetails = ko.observable(false);
      this.assignments = ko.observableArray();
      this.selectedPhase.subscribe(function(newValue) {
        return loadAssignments(newValue.id);
      });
      Resource.extend(RTeamMember);
    }

    PhasesViewmodel.prototype.load = function(data) {
      var a, act, activities, del, descr, icon, ms, obj, ph, proj, rel, relevantReleases, style, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _len6, _m, _n, _ref, _ref2, _ref3, _ref4;
      this.releases = [];
      this.displayData = [];
      relevantReleases = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          a = data[_i];
          if (a.isCurrent()) _results.push(a);
        }
        return _results;
      })();
      for (_i = 0, _len = relevantReleases.length; _i < _len; _i++) {
        rel = relevantReleases[_i];
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
          icon = '<span class="icon icon-milestone" />';
          style = 'style="color: green"';
          descr = '<ul>';
          _ref3 = ms.deliverables;
          for (_l = 0, _len4 = _ref3.length; _l < _len4; _l++) {
            del = _ref3[_l];
            console.log(del.title);
            descr += '<li>' + del.title + '<ul>';
            _ref4 = del.scope;
            for (_m = 0, _len5 = _ref4.length; _m < _len5; _m++) {
              proj = _ref4[_m];
              descr += '<li>' + proj.title;
              descr += '<ul>';
              activities = proj.workload.reduce(function(acc, x) {
                acc.push({
                  activityTitle: x.activity.title,
                  hrs: x.hoursRemaining,
                  planned: x.assignedResources.reduce((function(acc, x) {
                    return acc + x.resourceAvailableHours();
                  }), 0)
                });
                return acc;
              }, []);
              for (_n = 0, _len6 = activities.length; _n < _len6; _n++) {
                act = activities[_n];
                if (act.hrs > act.planned) {
                  icon = '<span class="icon icon-warning" />';
                  style = 'style="color: red"';
                } else {
                  style = 'style="color: green"';
                }
                descr += '<li ' + style + '>' + act.activityTitle + ': ' + act.hrs + ' hours remaining, ' + act.planned + ' hours planned</li>';
              }
              descr += '</ul>';
              descr += '</li>';
            }
            descr += '</ul>';
          }
          descr += '</li>';
          descr += '</ul>';
          obj = {
            group: rel.title,
            start: ms.date.date,
            content: ms.title + '<br />' + icon,
            info: ms.date.dateString + '<br />' + ms.description + '<br/>' + descr
          };
          this.displayData.push(obj);
        }
      }
      return this.showPhases = this.displayData.sort(function(a, b) {
        return a.start - b.end;
      });
    };

    PhasesViewmodel.prototype.setAssignments = function(jsonData) {
      this.assignments.removeAll();
      return this.assignments(AssignedResource.createCollection(jsonData));
    };

    PhasesViewmodel.prototype.loadAssignments = function(releaseId) {
      var ajax;
      ajax = new Ajax();
      return ajax.getAssignedResourcesForRelease(releaseId, this.setAssignments);
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
