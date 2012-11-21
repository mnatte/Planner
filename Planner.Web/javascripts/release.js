(function() {
  var Activity, AssignedResource, Deliverable, Feature, Milestone, Period, Phase, Project, ProjectActivityStatus, Release, ReleaseAssignments, Resource, Week, root,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  Period = (function(_super) {

    __extends(Period, _super);

    function Period(startDate, endDate, title, id) {
      this.title = title;
      this.id = id;
      this.startDate = new DatePlus(startDate);
      this.endDate = new DatePlus(endDate);
    }

    Period.prototype.days = function() {
      var days, diff, msPerDay;
      days = 0;
      msPerDay = 86400 * 1000;
      this.startDate.date.setHours(0, 0, 0, 1);
      this.endDate.date.setHours(23, 59, 59, 59, 999);
      diff = this.endDate.date - this.startDate.date;
      days = Math.ceil(diff / msPerDay);
      return days;
    };

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
      if (days < 0) {
        return 0;
      } else {
        return days;
      }
    };

    Period.prototype.workingHours = function() {
      return this.workingDays() * 8;
    };

    Period.prototype.toString = function() {
      return "" + this.title + " " + this.startDate.dateString + " - " + this.endDate.dateString + " (" + (this.workingDays()) + " working days) [" + (this.remainingWorkingDays()) + " remaining working days]";
    };

    Period.prototype.toShortString = function() {
      return "" + (this.startDate.format('dd/MM')) + " - " + (this.endDate.format('dd/MM'));
    };

    Period.prototype.containsDate = function(date) {
      return date.setHours(0, 0, 0, 0) >= this.startDate.date.setHours(0, 0, 0, 0) && date.setHours(0, 0, 0, 0) <= this.endDate.date.setHours(0, 0, 0, 0);
    };

    Period.prototype.isCurrent = function() {
      return this.containsDate(new Date());
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

    Period.prototype.workingDaysFromNow = function() {
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
      if (days < 0) {
        return 0;
      } else {
        return days;
      }
    };

    Period.prototype.remainingWorkingDays = function() {
      var amtDays;
      amtDays = 0;
      if (this.containsDate(new Date())) {
        amtDays = this.workingDaysFromNow();
      } else {
        amtDays = this.workingDays();
      }
      return amtDays;
    };

    Period.prototype.remainingWorkingHours = function() {
      return this.remainingWorkingDays() * 8;
    };

    Period.prototype.comingUpThisWeek = function() {
      var nextWeek, today;
      today = new Date();
      nextWeek = today.setDate(today.getDate() + 7);
      return nextWeek > this.startDate.date;
    };

    Period.prototype.overlaps = function(other) {
      var overlap;
      if (other !== void 0) {
        overlap = (this.startDate.date >= other.startDate.date && this.startDate.date <= other.endDate.date) || (this.endDate.date >= other.startDate.date && this.endDate.date <= other.endDate.date) || (other.startDate.date >= this.startDate.date && other.startDate.date <= this.endDate.date) || (other.endDate.date >= this.startDate.date && other.endDate.date <= this.endDate.date);
        return overlap;
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

    Period.prototype.weeks = function() {
      var endWeek, startWeek, wk, wks, yrstring;
      startWeek = getWeek(this.startDate.date);
      endWeek = getWeek(this.endDate.date);
      yrstring = this.startDate.date.getFullYear().toString();
      wks = [];
      for (wk = startWeek; startWeek <= endWeek ? wk <= endWeek : wk >= endWeek; startWeek <= endWeek ? wk++ : wk--) {
        wks.push(new Week(yrstring + wk.toString()));
      }
      return wks;
    };

    Period.create = function(jsonData) {
      return new Period(DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.Id);
    };

    return Period;

  })(Mixin);

  Milestone = (function(_super) {

    __extends(Milestone, _super);

    function Milestone(id, date, time, title, description, phaseId) {
      this.id = id;
      this.time = time;
      this.title = title;
      this.description = description;
      this.phaseId = phaseId;
      this.date = new DatePlus(date);
      this.deliverables = [];
    }

    Milestone.prototype.addDeliverable = function(deliverable) {
      return this.deliverables.push(deliverable);
    };

    Milestone.create = function(jsonData, phaseId) {
      var deliverable, ms, _i, _len, _ref;
      ms = new Milestone(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.Date), jsonData.Time, jsonData.Title, jsonData.Description, phaseId);
      _ref = jsonData.Deliverables;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        deliverable = _ref[_i];
        ms.addDeliverable(Deliverable.create(deliverable, ms));
      }
      return ms;
    };

    Milestone.createCollection = function(jsonData) {
      var milestones, ms, _i, _len;
      milestones = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        ms = jsonData[_i];
        this.ms = Milestone.create(ms);
        milestones.push(this.ms);
      }
      return milestones;
    };

    return Milestone;

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
      Phase.__super__.constructor.call(this, this.startDate, this.endDate, this.title, this.id);
    }

    Phase.create = function(jsonData, parentId) {
      return new Phase(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath, parentId);
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

  Week = (function() {

    function Week(weekNr) {
      this.weekNr = weekNr;
    }

    Week.prototype.period = function() {
      var enddate, jan10, jan4, startdate, week, wk1mon, year;
      year = parseInt(this.weekNr.substring(0, 4), 10);
      week = parseInt(this.weekNr.substring(4, 6), 10);
      jan10 = new Date(year, 0, 10, 12, 0, 0);
      jan4 = new Date(year, 0, 4, 12, 0, 0);
      wk1mon = new Date(jan4.getTime() - (jan10.getDay()) * 86400000);
      startdate = new Date(wk1mon.getTime() + (week - 1) * 604800000);
      enddate = new Date(startdate.getTime() + 518400000);
      return new Period(startdate, enddate, "week " + this.weekNr);
    };

    Week.prototype.shortNumber = function() {
      return parseInt(this.weekNr.substring(4, 6), 10);
    };

    return Week;

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
      this.milestones = [];
    }

    Release.prototype.addPhase = function(phase) {
      return this.phases.push(phase);
    };

    Release.prototype.addProject = function(project) {
      return this.projects.push(project);
    };

    Release.prototype.addMilestone = function(milestone) {
      return this.milestones.push(milestone);
    };

    Release.create = function(jsonData) {
      var milestone, phase, project, release, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath, jsonData.ParentId);
      _ref = jsonData.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        release.addPhase(Phase.create(phase, jsonData.Id));
      }
      _ref2 = jsonData.Projects;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        project = _ref2[_j];
        release.addProject(Project.create(project));
      }
      _ref3 = jsonData.Milestones;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        milestone = _ref3[_k];
        release.addMilestone(Milestone.create(milestone, jsonData.Id));
      }
      return release;
    };

    Release.createCollection = function(jsonDdata) {
      var rel, release, releases, _i, _len;
      releases = [];
      for (_i = 0, _len = jsonDdata.length; _i < _len; _i++) {
        release = jsonDdata[_i];
        rel = Release.create(release);
        releases.push(rel);
      }
      return releases;
    };

    return Release;

  })(Phase);

  Project = (function(_super) {

    __extends(Project, _super);

    function Project(id, title, shortName, descr, tfsIterationPath, tfsDevBranch, release) {
      this.id = id;
      this.title = title;
      this.shortName = shortName;
      this.descr = descr;
      this.tfsIterationPath = tfsIterationPath;
      this.tfsDevBranch = tfsDevBranch;
      this.release = release;
      this.resources = [];
      this.backlog = [];
      this.workload = [];
    }

    Project.create = function(jsonData, release) {
      var act, feature, project, res, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch, release);
      _ref = jsonData.AssignedResources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        res = _ref[_i];
        project.resources.push(AssignedResource.create(res, project, release));
      }
      _ref2 = jsonData.Backlog;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        feature = _ref2[_j];
        project.backlog.push(Feature.create(feature, project));
      }
      _ref3 = jsonData.Workload;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        act = _ref3[_k];
        project.workload.push(ProjectActivityStatus.create(act, project));
      }
      return project;
    };

    Project.createCollection = function(jsonData, release) {
      var project, projects, _i, _len;
      projects = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        project = jsonData[_i];
        this.project = Project.create(project, release);
        projects.push(this.project);
      }
      return projects;
    };

    return Project;

  })(Mixin);

  AssignedResource = (function(_super) {

    __extends(AssignedResource, _super);

    function AssignedResource(id, release, resource, project, focusFactor, startDate, endDate, activity, milestone, deliverable) {
      this.id = id;
      this.release = release;
      this.resource = resource;
      this.project = project;
      this.focusFactor = focusFactor;
      this.activity = activity;
      this.milestone = milestone;
      this.deliverable = deliverable;
      this.assignedPeriod = new Period(startDate, endDate, "");
    }

    AssignedResource.create = function(jsonData, project, release) {
      var activity, ass, deliverable, milestone, resource;
      resource = Resource.create(jsonData.Resource);
      milestone = Milestone.create(jsonData.Milestone);
      deliverable = Deliverable.create(jsonData.Deliverable);
      activity = Activity.create(jsonData.Activity);
      ass = new AssignedResource(jsonData.Id, release, resource, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), activity, milestone, deliverable);
      return ass;
    };

    AssignedResource.createCollection = function(jsonData, project, release) {
      var assignment, assignments, _i, _len;
      assignments = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        assignment = jsonData[_i];
        this.assignment = AssignedResource.create(assignment, project, release);
        assignments.push(this.assignment);
      }
      return assignments;
    };

    AssignedResource.prototype.availableHours = function() {
      var available, hoursPresent;
      hoursPresent = this.resource.hoursAvailable(this.assignedPeriod);
      available = Math.round(hoursPresent * this.focusFactor);
      return available;
    };

    return AssignedResource;

  })(Mixin);

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

  Deliverable = (function(_super) {

    __extends(Deliverable, _super);

    function Deliverable(id, title, description, format, location, milestone) {
      this.id = id;
      this.title = title;
      this.description = description;
      this.format = format;
      this.location = location;
      this.milestone = milestone;
      this.activities = [];
      this.scope = [];
    }

    Deliverable.create = function(jsonData, milestone) {
      var act, deliverable, project, _i, _j, _len, _len2, _ref, _ref2;
      deliverable = new Deliverable(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.Format, jsonData.Location, milestone);
      _ref = jsonData.ConfiguredActivities;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        act = _ref[_i];
        deliverable.activities.push(Activity.create(act));
      }
      _ref2 = jsonData.Scope;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        project = _ref2[_j];
        deliverable.scope.push(Project.create(project));
      }
      return deliverable;
    };

    Deliverable.createCollection = function(jsonData) {
      var del, deliverables, _i, _len;
      deliverables = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        del = jsonData[_i];
        this.del = Deliverable.create(del);
        deliverables.push(this.del);
      }
      return deliverables;
    };

    return Deliverable;

  })(Mixin);

  ProjectActivityStatus = (function(_super) {

    __extends(ProjectActivityStatus, _super);

    function ProjectActivityStatus(hoursRemaining, activity) {
      this.hoursRemaining = hoursRemaining;
      this.activity = activity;
      this.assignedResources = [];
    }

    ProjectActivityStatus.create = function(jsonData, project) {
      var act, res, status, _i, _len, _ref;
      act = Activity.create(jsonData.Activity);
      status = new ProjectActivityStatus(jsonData.HoursRemaining, act);
      _ref = jsonData.AssignedResources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        res = _ref[_i];
        status.assignedResources.push(AssignedResource.create(res, project));
      }
      return status;
    };

    return ProjectActivityStatus;

  })(Mixin);

  Activity = (function(_super) {

    __extends(Activity, _super);

    function Activity(id, title, description) {
      this.id = id;
      this.title = title;
      this.description = description;
    }

    Activity.create = function(jsonData) {
      return new Activity(jsonData.Id, jsonData.Title, jsonData.Description);
    };

    Activity.createCollection = function(jsonData) {
      var act, activities, _i, _len;
      activities = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        act = jsonData[_i];
        this.act = Activity.create(act);
        activities.push(this.act);
      }
      return activities;
    };

    return Activity;

  })(Mixin);

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
      this.assignments = [];
    }

    Resource.prototype.addAbsence = function(period) {
      return this.periodsAway.push(period);
    };

    Resource.prototype.addAssignment = function(per, rel, act, ff) {
      return this.assignments.push({
        period: per,
        release: rel,
        activity: act,
        focusFactor: ff
      });
    };

    Resource.prototype.fullName = function() {
      var middle;
      if (this.middleName.length === 0) middle = " ";
      if (this.middleName.length > 0) middle = " " + this.middleName + " ";
      return this.firstName + middle + this.lastName;
    };

    Resource.prototype.isPresent = function(date) {
      var absence, away, _i, _len, _ref;
      _ref = this.periodsAway;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        absence = _ref[_i];
        if (absence.containsDate(date)) away = absence;
      }
      return away.length === 0;
    };

    Resource.create = function(jsonData) {
      var absence, assignment, res, _i, _j, _len, _len2, _ref, _ref2;
      res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber);
      _ref = jsonData.PeriodsAway;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        absence = _ref[_i];
        res.addAbsence(new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Id));
      }
      _ref2 = jsonData.Assignments;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        assignment = _ref2[_j];
        res.addAssignment(new Period(DateFormatter.createJsDateFromJson(assignment.StartDate), DateFormatter.createJsDateFromJson(assignment.EndDate), assignment.Activity.Title + " " + assignment.Phase.Title + " (" + assignment.FocusFactor + ")"), assignment.Phase.Title, assignment.Activity, assignment.FocusFactor);
      }
      return res;
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

    Resource.prototype.toString = function() {
      return this.fullName();
    };

    return Resource;

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

  root.Week = Week;

  root.Phase = Phase;

  root.Milestone = Milestone;

  root.Release = Release;

  root.Feature = Feature;

  root.Resource = Resource;

  root.Project = Project;

  root.Deliverable = Deliverable;

  root.Activity = Activity;

  root.AssignedResource = AssignedResource;

  root.ProjectActivityStatus = ProjectActivityStatus;

  root.ReleaseAssignments = ReleaseAssignments;

}).call(this);
