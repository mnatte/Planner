(function() {
  var Feature, MileStone, Phase, Release, root,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  Phase = (function(_super) {

    __extends(Phase, _super);

    function Phase(startDate, endDate, workingDays, title) {
      this.startDate = startDate;
      this.endDate = endDate;
      this.workingDays = workingDays;
      this.title = title;
      this.workingHours = this.workingDays * 8;
    }

    Phase.prototype.toString = function() {
      return "" + this.title + " " + this.startDate + " - " + this.endDate + " (" + this.workingDays + " working days)";
    };

    return Phase;

  })(Mixin);

  MileStone = (function() {

    function MileStone(date, title) {
      this.date = date;
      this.title = title;
    }

    return MileStone;

  })();

  Release = (function(_super) {

    __extends(Release, _super);

    function Release(startDate, endDate, workingDays, title) {
      this.startDate = startDate;
      this.endDate = endDate;
      this.workingDays = workingDays;
      this.title = title;
      Release.__super__.constructor.apply(this, arguments);
      this.phases = [];
      this.backlog = [];
    }

    Release.prototype.addPhase = function(phase) {
      return this.phases.push(phase);
    };

    Release.prototype.addFeature = function(feature) {
      return this.backlog.push(feature);
    };

    return Release;

  })(Phase);

  Feature = (function() {

    function Feature(businessId, contactPerson, estimatedHours, hoursWorked, priority, project, remainingHours, title, state) {
      this.businessId = businessId;
      this.contactPerson = contactPerson;
      this.estimatedHours = estimatedHours;
      this.hoursWorked = hoursWorked;
      this.priority = priority;
      this.project = project;
      this.remainingHours = remainingHours;
      this.title = title;
      this.state = state;
    }

    return Feature;

  })();

  root.Phase = Phase;

  root.MileStone = MileStone;

  root.Release = Release;

  root.Feature = Feature;

}).call(this);
