(function() {
  var AssignedResource, Feature, MileStone, Period, Phase, Project, Release, ReleaseAssignments, Resource, root,
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

    Period.prototype.overlappingPeriod = function(other) {
      var endDate, startDate;
      if (!(other === void 0 || !this.overlaps(other))) {
        if (this.startDate.date > other.startDate.date) {
          startDate = this.startDate.date;
        } else {
          startDate = other.startDate.date;
        }
        if (this.endDate.date < other.endDate.date) {
          endDate = this.endDate.date;
        } else {
          endDate = other.endDate.date;
        }
        return new Period(startDate, endDate, "overlapping period");
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

    Phase.create = function(jsonData) {
      return new Phase(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath, jsonData.ParentId);
    };

    Phase.createCollection = function(jsonData) {
      var phase, phases, _i, _len;
      phases = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        phase = jsonData[_i];
        this.phase = Phase.create(phase);
        phases.push(this.phase);
      }
      return phases;
    };

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
      this.projects = [];
    }

    Release.prototype.addPhase = function(phase) {
      return this.phases.push(phase);
    };

    Release.prototype.addProject = function(project) {
      return this.projects.push(project);
    };

    Release.create = function(jsonData) {
      var feat, phase, project, release, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath, jsonData.ParentId);
      _ref = jsonData.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        release.addPhase(Phase.create(phase));
      }
      _ref2 = jsonData.Backlog;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        feat = _ref2[_j];
        console.log(feat);
        release.addFeature(Feature.create(feat));
      }
      _ref3 = jsonData.Projects;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        project = _ref3[_k];
        release.addProject(Project.create(project));
      }
      return release;
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

    Feature.create = function(jsonData, project) {
      var feature;
      feature = new Feature(jsonData.BusinessId, jsonData.ContactPerson, jsonData.EstimatedHours, jsonData.HoursWorked, jsonData.Priority, project, jsonData.RemainingHours, jsonData.Title, jsonData.Status);
      return feature;
    };

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
      this.resources = [];
      this.backlog = [];
    }

    Project.create = function(jsonData) {
      var feature, project, res, _i, _j, _len, _len2, _ref, _ref2;
      project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch);
      _ref = jsonData.AssignedResources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        res = _ref[_i];
        this.resources.push(AssignedResource.create(res, project));
      }
      _ref2 = jsonData.Backlog;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        feature = _ref2[_j];
        this.backlog.push(Feature.create(feature, project));
      }
      return project;
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

  AssignedResource = (function(_super) {

    __extends(AssignedResource, _super);

    function AssignedResource(id, phaseId, phaseTitle, resourceId, firstName, middleName, lastName, project, focusFactor, startDate, endDate) {
      this.id = id;
      this.focusFactor = focusFactor;
      this.resource = new Resource(resourceId, firstName, middleName, lastName);
      this.project = new Project(projectId, projectTitle);
      this.phase = new Phase(phaseId, "", "", phaseTitle);
      this.assignedPeriod = new Period(startDate, endDate, "");
    }

    AssignedResource.create = function(jsonData, project) {
      return new AssignedResource(jsonData.Id, jsonData.Phase.Id, jsonData.Phase.Title, jsonData.Resource.Id, jsonData.Resource.FirstName, jsonData.Resource.MiddleName, jsonData.Resource.LastName, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate));
    };

    AssignedResource.createCollection = function(jsonData) {
      var assignment, assignments, _i, _len;
      assignments = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        assignment = jsonData[_i];
        this.assignment = AssignedResource.create(assignment);
        assignments.push(this.assignment);
      }
      return assignments;
    };

    AssignedResource.prototype.toJSON = function() {
      var copy;
      copy = ko.toJS(this);
      delete copy.phase;
      delete copy.resource;
      delete copy.project;
      delete copy.assignedPeriod;
      copy.resourceId = this.resource.id;
      copy.phaseId = this.phase.id;
      copy.projectId = this.project.id;
      copy.startDate = this.assignedPeriod.startDate.dateString;
      copy.endDate = this.assignedPeriod.endDate.dateString;
      return copy;
    };

    return AssignedResource;

  })(Mixin);

  ReleaseAssignments = (function(_super) {

    __extends(ReleaseAssignments, _super);

    function ReleaseAssignments(phaseId, projectId, assignments) {
      this.phaseId = phaseId;
      this.projectId = projectId;
      this.assignments = assignments;
    }

    return ReleaseAssignments;

  })(Mixin);

  root.Period = Period;

  root.Phase = Phase;

  root.MileStone = MileStone;

  root.Release = Release;

  root.Feature = Feature;

  root.Resource = Resource;

  root.Project = Project;

  root.AssignedResource = AssignedResource;

  root.ReleaseAssignments = ReleaseAssignments;

}).call(this);
