(function() {
  var RDeliverableSerialize, RMilestoneSerialize, RReleaseSerialize, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  RReleaseSerialize = {
    extended: function() {
      return this.include({
        toConfigurationSnapshot: function() {
          var copy, ms, phase, _i, _j, _len, _len2, _ref, _ref2;
          copy = ko.toJS(this);
          copy.projects = this.projects.reduce(function(acc, x) {
            acc.push(x.id);
            return acc;
          }, []);
          copy.milestones = [];
          _ref = this.milestones;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            ms = _ref[_i];
            copy.milestones.push(ms.toConfigurationSnapshot());
          }
          copy.phases = [];
          _ref2 = this.phases;
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            phase = _ref2[_j];
            copy.phases.push(phase.toConfigurationSnapshot());
          }
          return copy;
        }
      });
    }
  };

  RMilestoneSerialize = {
    extended: function() {
      return this.include({
        toJSON: function() {
          var copy;
          copy = ko.toJS(this);
          delete copy.date.date;
          copy.date = this.date.dateString;
          return copy;
        },
        toConfigurationSnapshot: function() {
          var copy;
          copy = ko.toJS(this);
          copy.deliverables = this.deliverables.reduce(function(acc, x) {
            acc.push(x.id);
            return acc;
          }, []);
          return copy;
        }
      });
    }
  };

  RDeliverableSerialize = {
    extended: function() {
      return this.include({
        toStatusJSON: function() {
          var copy, proj, _i, _len, _ref;
          copy = ko.toJS(this);
          delete copy.title;
          delete copy.description;
          delete copy.format;
          delete copy.location;
          delete copy.activities;
          delete copy.milestone;
          copy.releaseId = this.milestone.phaseId;
          copy.milestoneId = this.milestone.id;
          copy.deliverableId = this.id;
          copy.scope = [];
          _ref = this.scope;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            proj = _ref[_i];
            copy.scope.push(proj.toStatusJSON());
          }
          return copy;
        },
        toConfigurationSnapshot: function() {
          var copy;
          copy = ko.toJS(this);
          delete copy.title;
          delete copy.description;
          delete copy.format;
          delete copy.location;
          delete copy.activities;
          delete copy.scope;
          delete copy.milestone;
          return copy;
        }
      });
    }
  };

  root.RMilestoneSerialize = RMilestoneSerialize;

  root.RDeliverableSerialize = RDeliverableSerialize;

  root.RReleaseSerialize = RReleaseSerialize;

}).call(this);
