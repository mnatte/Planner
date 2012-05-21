(function() {
  var Feature, MileStone, Period, Phase, Project, Release, Resource, root,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  Period = (function(_super) {

    __extends(Period, _super);

    function Period(startDate, endDate, title) {
      this.title = title;
      this.startDate = new DatePlus(startDate);
      this.endDate = new DatePlus(endDate);
    }

    Period.prototype.workingDays = function() {
      var days, diff, endDay, msPerDay, startDay, weeks;
      days = 0;
      msPerDay = 86400 * 1000;
      this.startDate.date.setHours(0, 0, 0, 1);
      this.endDate.date.setHours(23, 59, 59, 59, 999);
      diff = this.endDate.date - this.startDate.date;
      days = Math.ceil(diff / msPerDay);
      weeks = Math.floor(days / 7);
      days = days - (weeks * 2);
      startDay = this.startDate.date.getDay();
      endDay = this.endDate.date.getDay();
      if (startDay - endDay > 1) days = days - 2;
      if (startDay === 0 && endDay !== 6) days = days - 1;
      if (endDay === 6 && startDay !== 0) days = days - 1;
      return days;
    };

    Period.prototype.workingHours = function() {
      return this.workingDays() * 8;
    };

    Period.prototype.toString = function() {
      return "" + this.title + " " + this.startDate.dateString + " - " + this.endDate.dateString + " (" + (this.workingDays()) + " working days)";
    };

    Period.prototype.isCurrent = function() {
      var today;
      today = new Date();
      return today >= this.startDate.date && today < this.endDate.date;
    };

    Period.prototype.isFuture = function() {
      var today;
      today = new Date();
      return today < this.startDate.date;
    };

    Period.prototype.isPast = function() {
      var today;
      today = new Date();
      return today > this.startDate.date;
    };

    Period.prototype.startDaysFromNow = function() {
      var ONE_DAY, date1_ms, date2_ms, difference_ms;
      if (this.isFuture()) {
        ONE_DAY = 1000 * 60 * 60 * 24;
        date1_ms = new Date().getTime();
        date2_ms = this.startDate.date.getTime();
        difference_ms = Math.abs(date2_ms - date1_ms);
        return Math.round(difference_ms / ONE_DAY);
      } else {
        return 1;
      }
    };

    Period.prototype.remainingDays = function() {
      var ONE_DAY, date1_ms, date2_ms, difference_ms;
      ONE_DAY = 1000 * 60 * 60 * 24;
      date1_ms = new Date().getTime();
      date2_ms = this.endDate.date.getTime();
      difference_ms = Math.abs(date1_ms - date2_ms);
      return Math.round(difference_ms / ONE_DAY);
    };

    Period.prototype.workingDaysRemaining = function() {
      var days, diff, endDay, msPerDay, startDay, today, weeks;
      days = 0;
      msPerDay = 86400 * 1000;
      today = new Date();
      today.setHours(0, 0, 0, 1);
      this.endDate.date.setHours(23, 59, 59, 59, 999);
      diff = this.endDate.date - today;
      days = Math.ceil(diff / msPerDay);
      weeks = Math.floor(days / 7);
      days = days - (weeks * 2);
      startDay = today.getDay();
      endDay = this.endDate.date.getDay();
      if (startDay - endDay > 1) days = days - 2;
      if (startDay === 0 && endDay !== 6) days = days - 1;
      if (endDay === 6 && startDay !== 0) days = days - 1;
      return days;
    };

    Period.prototype.comingUpThisWeek = function() {
      var nextWeek, today;
      today = new Date();
      nextWeek = today.setDate(today.getDate() + 7);
      return nextWeek > this.startDate.date;
    };

    Period.prototype.overlaps = function(other) {
      if (other !== void 0) {
        return (this.startDate.date >= other.startDate.date && this.startDate.date < other.endDate.date) || (this.endDate.date >= other.startDate.date && this.endDate.date < other.endDate.date);
      }
    };

    Period.prototype.toJSON = function() {
      var copy;
      copy = ko.toJS(this);
      delete copy.startDate.date;
      copy.startDate = this.startDate.dateString;
      copy.endDate = this.endDate.dateString;
      return copy;
    };

    return Period;

  })(Mixin);

  Phase = (function(_super) {

    __extends(Phase, _super);

    function Phase(id, startDate, endDate, title, tfsIterationPath, parentId) {
      this.id = id;
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
      this.tfsIterationPath = tfsIterationPath;
      this.parentId = parentId;
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

    function Release(id, startDate, endDate, title, tfsIterationPath, parentId) {
      this.id = id;
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
      this.tfsIterationPath = tfsIterationPath;
      this.parentId = parentId;
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

    function Resource(id, firstName, middleName, lastName, initials, hoursPerWeek, email, phoneNumber, company, _function) {
      this.id = id;
      this.firstName = firstName;
      this.middleName = middleName;
      this.lastName = lastName;
      this.initials = initials;
      this.hoursPerWeek = hoursPerWeek;
      this.email = email;
      this.phoneNumber = phoneNumber;
      this.company = company;
      this["function"] = _function;
      this.periodsAway = [];
    }

    Resource.prototype.addAbsence = function(period) {
      return this.periodsAway.push(period);
    };

    Resource.prototype.fullName = function() {
      var middle;
      if (this.middleName.length === 0) middle = " ";
      if (this.middleName.length > 0) middle = " " + this.middleName + " ";
      return this.firstName + middle + this.lastName;
    };

    Resource.create = function(jsonData) {
      return new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber);
    };

    Resource.createCollection = function(jsonData) {
      var resource, resources, _i, _len;
      resources = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        resource = jsonData[_i];
        this.resource = Resource.create(resource);
        resources.push(this.resource);
      }
      return resources;
    };

    return Resource;

  })(Mixin);

  Project = (function(_super) {

    __extends(Project, _super);

    function Project(id, title, shortName, descr, tfsIterationPath, tfsDevBranch) {
      this.id = id;
      this.title = title;
      this.shortName = shortName;
      this.descr = descr;
      this.tfsIterationPath = tfsIterationPath;
      this.tfsDevBranch = tfsDevBranch;
    }

    Project.create = function(jsonData) {
      return new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch);
    };

    Project.createCollection = function(jsonData) {
      var project, projects, _i, _len;
      projects = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        project = jsonData[_i];
        this.project = Project.create(project);
        projects.push(this.project);
      }
      return projects;
    };

    return Project;

  })(Mixin);

  root.Period = Period;

  root.Phase = Phase;

  root.MileStone = MileStone;

  root.Release = Release;

  root.Feature = Feature;

  root.Resource = Resource;

  root.Project = Project;

}).call(this);
