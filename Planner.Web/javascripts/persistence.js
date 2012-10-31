(function() {
  var RAssignedResourceSerialize, RDeliverableSerialize, RMilestoneSerialize, RPeriodSerialize, RPhaseSerialize, RProjectSerialize, RReleaseSerialize, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  RPeriodSerialize = {
    extended: function() {
      return this.include({
        toJSON: function() {
          var copy;
          copy = ko.toJS(this);
          delete copy.startDate.date;
          copy.startDate = this.startDate.dateString;
          copy.endDate = this.endDate.dateString;
          return copy;
        }
      });
    }
  };

  RReleaseSerialize = {
    extended: function() {
      return this.include({
        toConfigurationSnapshotJson: function() {
          var copy, graph, ms, phase, _i, _j, _len, _len2, _ref, _ref2;
          console.log(this);
          copy = ko.toJS(this);
          copy.projects = this.projects().reduce(function(acc, x) {
            acc.push(x.id);
            return acc;
          }, []);
          copy.milestones = [];
          _ref = this.milestones();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            ms = _ref[_i];
            copy.milestones.push(ms.toConfigurationSnapshot());
          }
          copy.phases = [];
          _ref2 = this.phases();
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            phase = _ref2[_j];
            copy.phases.push(phase.toConfigurationSnapshot());
          }
          graph = ko.toJSON(copy);
          return graph;
        }
      });
    }
  };

  RProjectSerialize = {
    extended: function() {
      return this.include({
        toStatusJSON: function() {
          var copy;
          copy = ko.toJS(this);
          delete copy.title;
          delete copy.shortName;
          delete copy.descr;
          delete copy.backlog;
          delete copy.tfsIterationPath;
          delete copy.tfsDevBranch;
          delete copy.release;
          delete copy.resources;
          return copy;
        },
        toConfigurationSnapshot: function() {
          var copy;
          copy = ko.toJS(this);
          delete copy.resources;
          delete copy.backlog;
          delete copy.workload;
          return copy;
        }
      });
    }
  };

  RPhaseSerialize = {
    extended: function() {
      return this.include({
        toConfigurationSnapshot: function() {
          var copy;
          copy = ko.toJS(this);
          console.log("RPhaseSerialize");
          console.log(copy);
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
          copy.deliverables = this.deliverables().reduce(function(acc, x) {
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

  RAssignedResourceSerialize = {
    extended: function() {
      return this.include({
        toJSON: function() {
          var copy;
          copy = ko.toJS(this);
          delete copy.release;
          delete copy.phase;
          delete copy.resource;
          delete copy.project;
          delete copy.assignedPeriod;
          delete copy.milestone;
          delete copy.deliverable;
          delete copy.activity;
          copy.resourceId = this.resource.id;
          if (this.release != null) copy.phaseId = this.release.id;
          copy.projectId = this.project.id;
          copy.startDate = this.assignedPeriod.startDate.dateString;
          copy.endDate = this.assignedPeriod.endDate.dateString;
          copy.milestoneId = this.milestone.id;
          copy.deliverableId = this.deliverable.id;
          copy.activityId = this.activity.id;
          return copy;
        }
      });
    }
  };

  root.RMilestoneSerialize = RMilestoneSerialize;

  root.RDeliverableSerialize = RDeliverableSerialize;

  root.RReleaseSerialize = RReleaseSerialize;

  root.RAssignedResourceSerialize = RAssignedResourceSerialize;

  root.RPhaseSerialize = RPhaseSerialize;

  root.RProjectSerialize = RProjectSerialize;

  root.RPeriodSerialize = RPeriodSerialize;

}).call(this);
