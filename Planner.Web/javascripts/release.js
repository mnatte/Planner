(function() {
  var Feature, MileStone, Period, Phase, Release, Resource, root,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  Period = (function(_super) {

    __extends(Period, _super);

    function Period(startDate, endDate, title) {
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
    }

    Period.prototype.workingDays = function() {
      var days, diff, endDay, msPerDay, startDay, weeks;
      days = 0;
      msPerDay = 86400 * 1000;
      this.startDate.setHours(0, 0, 0, 1);
      this.endDate.setHours(23, 59, 59, 59, 999);
      diff = this.endDate - this.startDate;
      days = Math.ceil(diff / msPerDay);
      weeks = Math.floor(days / 7);
      days = days - (weeks * 2);
      startDay = this.startDate.getDay();
      endDay = this.endDate.getDay();
      if (startDay - endDay > 1) days = days - 2;
      if (startDay === 0 && endDay !== 6) days = days - 1;
      if (endDay === 6 && startDay !== 0) days = days - 1;
      return days;
    };

    Period.prototype.workingHours = function() {
      return this.workingDays() * 8;
    };

    Period.prototype.toString = function() {
      return "" + this.title + " " + (DateFormatter.formatJsDate(this.startDate, 'dd/MM/yyyy')) + " - " + (DateFormatter.formatJsDate(this.endDate, 'dd/MM/yyyy')) + " (" + (this.workingDays()) + " working days)";
    };

    Period.prototype.isCurrent = function() {
      var today;
      today = new Date();
      return today >= this.startDate && today < this.endDate;
    };

    Period.prototype.isFuture = function() {
      var today;
      today = new Date();
      return today < this.startDate;
    };

    Period.prototype.isPast = function() {
      var today;
      today = new Date();
      return today > this.startDate;
    };

    Period.prototype.comingUpThisWeek = function() {
      var nextWeek, today;
      today = new Date();
      nextWeek = today.setDate(today.getDate() + 7);
      return nextWeek > this.startDate;
    };

    Period.prototype.overlaps = function(other) {
      if (other !== void 0) {
        return (this.startDate >= other.startDate && this.startDate < other.endDate) || (this.endDate >= other.startDate && this.endDate < other.endDate);
      }
    };

    return Period;

  })(Mixin);

  Phase = (function(_super) {

    __extends(Phase, _super);

    function Phase(id, startDate, endDate, title, tfsIterationPath) {
      this.id = id;
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
      this.tfsIterationPath = tfsIterationPath;
      Phase.__super__.constructor.call(this, this.startDate, this.endDate, this.title);
    }

    return Phase;

  })(Period);

  MileStone = (function() {

    function MileStone(date, title) {
      this.date = date;
      this.title = title;
    }

    return MileStone;

  })();

  Release = (function(_super) {

    __extends(Release, _super);

    function Release(id, startDate, endDate, title, tfsIterationPath) {
      this.id = id;
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
      this.tfsIterationPath = tfsIterationPath;
      Release.__super__.constructor.apply(this, arguments);
      this.phases = [];
      this.backlog = [];
      this.resources = [];
    }

    Release.prototype.addPhase = function(phase) {
      return this.phases.push(phase);
    };

    Release.prototype.addFeature = function(feature) {
      return this.backlog.push(feature);
    };

    Release.prototype.addResource = function(resource) {
      return this.resources.push(resource);
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

  Resource = (function(_super) {

    __extends(Resource, _super);

    function Resource(firstName, middleName, lastName, initials, hoursPerWeek, _function) {
      this.firstName = firstName;
      this.middleName = middleName;
      this.lastName = lastName;
      this.initials = initials;
      this.hoursPerWeek = hoursPerWeek;
      this["function"] = _function;
      this.periodsAway = [];
    }

    Resource.prototype.addAbsence = function(period) {
      return this.periodsAway.push(period);
    };

    return Resource;

  })(Mixin);

  root.Period = Period;

  root.Phase = Phase;

  root.MileStone = MileStone;

  root.Release = Release;

  root.Feature = Feature;

  root.Resource = Resource;

}).call(this);
