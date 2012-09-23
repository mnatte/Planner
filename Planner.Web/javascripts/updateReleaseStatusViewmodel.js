(function() {
  var UpdateReleaseStatusViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  UpdateReleaseStatusViewmodel = (function() {

    function UpdateReleaseStatusViewmodel(allReleases) {
      var rel, _fn, _i, _len, _ref;
      this.allReleases = allReleases;
      this.saveSelectedDeliverable = __bind(this.saveSelectedDeliverable, this);
      this.refreshRelease = __bind(this.refreshRelease, this);
      this.selectDeliverable = __bind(this.selectDeliverable, this);
      this.selectMilestone = __bind(this.selectMilestone, this);
      this.selectRelease = __bind(this.selectRelease, this);
      Phase.extend(RCrud);
      Milestone.extend(RCrud);
      this.selectedRelease = ko.observable();
      this.selectedMilestone = ko.observable();
      this.selectedDeliverable = ko.observable();
      this.selectedProject = ko.observable();
      _ref = this.allReleases;
      _fn = function(rel) {
        return rel.milestones.sort(function(a, b) {
          if (a.date.date > b.date.date) {
            return 1;
          } else if (a.date.date < b.date.date) {
            return -1;
          } else {
            return 0;
          }
        });
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rel = _ref[_i];
        _fn(rel);
      }
      this.allReleases.sort(function(a, b) {
        if (a.startDate.date > b.startDate.date) {
          return 1;
        } else if (a.startDate.date < b.startDate.date) {
          return -1;
        } else {
          return 0;
        }
      });
    }

    UpdateReleaseStatusViewmodel.prototype.selectRelease = function(data) {
      console.log("selectRelease - function");
      this.selectedRelease(data);
      console.log(this.selectedRelease.projects);
      this.selectMilestone(null);
      return this.selectDeliverable(null);
    };

    UpdateReleaseStatusViewmodel.prototype.selectMilestone = function(data) {
      console.log("selectMilestone - function");
      this.selectedMilestone(data);
      this.selectDeliverable(null);
      return console.log(this.selectedMilestone());
    };

    UpdateReleaseStatusViewmodel.prototype.selectDeliverable = function(data) {
      console.log("selectDeliverable - function");
      this.selectedDeliverable(data);
      return console.log(this.selectedDeliverable());
    };

    UpdateReleaseStatusViewmodel.prototype.refreshRelease = function(index, jsonData) {};

    UpdateReleaseStatusViewmodel.prototype.saveSelectedDeliverable = function() {
      var i;
      console.log("saveSelectedDeliverable: selectedRelease: " + (this.selectedRelease()));
      console.log("saveSelectedDeliverable: selectedMilestone: " + (this.selectedDeliverable()));
      console.log(ko.toJSON(this.selectedDeliverable()));
      console.log(ko.toJSON(this.selectedDeliverable().milestoneId));
      return i = this.allReleases().indexOf(this.selectedRelease());
    };

    return UpdateReleaseStatusViewmodel;

  })();

  root.UpdateReleaseStatusViewmodel = UpdateReleaseStatusViewmodel;

}).call(this);
