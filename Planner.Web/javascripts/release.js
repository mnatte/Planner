(function() {
  var Activity, Assignment, Deliverable, Environment, Feature, Meeting, Milestone, Period, Phase, Process, Project, ProjectActivityStatus, Release, ReleaseAssignments, Resource, Version, Week, root,
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
      } else if (new Date() < this.endDate.date) {
        amtDays = this.workingDays();
      }
      return amtDays;
    };

    Period.prototype.remainingWorkingHours = function() {
      return this.remainingWorkingDays() * 8;
    };

    Period.prototype.comingUpThisWeek = function() {
      return this.comingUpInDays(7);
    };

    Period.prototype.comingUpInDays = function(amtDays) {
      var next, period, today;
      today = new Date();
      console.log(today);
      next = today.setDate(today.getDate() + amtDays);
      console.log(new Date(next));
      period = new Period(new Date(), new Date(next), 'compare comingUpInDays');
      console.log(period);
      return this.overlaps(period);
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

    Period.prototype.remainingPeriod = function() {
      var periodFromNow;
      periodFromNow = new Period(new Date(), this.endDate.date);
      return this.overlappingPeriod(periodFromNow);
    };

    Period.create = function(jsonData) {
      return new Period(DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.Id);
    };

    Period.createFromNow = function(endDate) {
      return new Period(new Date(), endDate);
    };

    return Period;

  })(Mixin);

  Milestone = (function(_super) {

    __extends(Milestone, _super);

    function Milestone(id, date, time, title, description, phaseId, phaseTitle) {
      this.id = id;
      this.time = time;
      this.title = title;
      this.description = description;
      this.phaseId = phaseId;
      this.phaseTitle = phaseTitle;
      this.date = new DatePlus(date);
      this.deliverables = [];
    }

    Milestone.prototype.addDeliverable = function(deliverable) {
      return this.deliverables.push(deliverable);
    };

    Milestone.create = function(jsonData, phaseId, phaseTitle) {
      var deliverable, ms, _i, _len, _ref;
      ms = new Milestone(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.Date), jsonData.Time, jsonData.Title, jsonData.Description, phaseId, phaseTitle);
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

  Environment = (function(_super) {

    __extends(Environment, _super);

    function Environment(id, name, description, location, shortName) {
      this.id = id;
      this.name = name;
      this.description = description;
      this.location = location;
      this.shortName = shortName;
      this.planning = [];
    }

    Environment.create = function(jsonData) {
      var a, env, phase, version, _i, _len, _ref;
      env = new Environment(jsonData.Id, jsonData.Name, jsonData.Description, jsonData.Location, jsonData.ShortName);
      _ref = jsonData.Planning;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        a = _ref[_i];
        phase = Phase.create(a.Phase);
        version = Version.create(a.Version);
        env.planning.push({
          phase: phase,
          version: version
        });
      }
      return env;
    };

    Environment.createCollection = function(jsonData) {
      var arr, e, _i, _len;
      arr = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        e = jsonData[_i];
        this.env = Environment.create(e);
        arr.push(this.env);
      }
      return arr;
    };

    return Environment;

  })(Mixin);

  Version = (function(_super) {

    __extends(Version, _super);

    function Version(id, number, description, name) {
      this.id = id;
      this.number = number;
      this.description = description;
      this.name = name;
    }

    Version.create = function(jsonData) {
      var v;
      v = new Version(jsonData.Id, jsonData.Number, jsonData.Description, jsonData.Name);
      return v;
    };

    Version.createCollection = function(jsonData) {
      var arr, e, _i, _len;
      arr = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        e = jsonData[_i];
        this.v = Version.create(e);
        arr.push(this.v);
      }
      return arr;
    };

    return Version;

  })(Mixin);

  Process = (function(_super) {

    __extends(Process, _super);

    function Process(id, title, description, shortName, type) {
      this.id = id;
      this.title = title;
      this.description = description;
      this.shortName = shortName;
      this.type = type;
    }

    Process.create = function(jsonData) {
      var item;
      item = new Process(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.ShortName, jsonData.Type);
      return item;
    };

    Process.createEmpty = function() {
      var item;
      item = new Process(0, "", "", "", "");
      return item;
    };

    Process.createCollection = function(jsonData) {
      var arr, i, _i, _len;
      arr = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        i = jsonData[_i];
        this.item = Process.create(i);
        arr.push(this.item);
      }
      return arr;
    };

    return Process;

  })(Mixin);

  Phase = (function(_super) {

    __extends(Phase, _super);

    function Phase(id, startDate, endDate, title, parentId) {
      this.id = id;
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
      this.parentId = parentId;
      Phase.__super__.constructor.call(this, this.startDate, this.endDate, this.title, this.id);
    }

    Phase.create = function(jsonData, parentId) {
      return new Phase(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, parentId);
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

    function Release(id, startDate, endDate, title, parentId) {
      this.id = id;
      this.startDate = startDate;
      this.endDate = endDate;
      this.title = title;
      this.parentId = parentId;
      Release.__super__.constructor.apply(this, arguments);
      this.phases = [];
      this.projects = [];
      this.milestones = [];
      this.meetings = [];
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

    Release.prototype.addMeeting = function(meeting) {
      return this.meetings.push(meeting);
    };

    Release.create = function(jsonData) {
      var meeting, milestone, phase, project, release, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3, _ref4;
      release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.ParentId);
      if (jsonData.Phases !== null && jsonData.Phases !== void 0) {
        _ref = jsonData.Phases;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          phase = _ref[_i];
          release.addPhase(Phase.create(phase, jsonData.Id));
        }
      }
      if (jsonData.Projects !== null && jsonData.Projects !== void 0) {
        _ref2 = jsonData.Projects;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          project = _ref2[_j];
          release.addProject(Project.create(project));
        }
      }
      if (jsonData.Milestones !== null && jsonData.Milestones !== void 0) {
        _ref3 = jsonData.Milestones;
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          milestone = _ref3[_k];
          release.addMilestone(Milestone.create(milestone, jsonData.Id, jsonData.Title));
        }
      }
      if (jsonData.Meetings !== null && jsonData.Meetings !== void 0) {
        _ref4 = jsonData.Meetings;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          meeting = _ref4[_l];
          release.addMeeting(Meeting.create(meeting, jsonData.Id));
        }
      }
      return release;
    };

    Release.createSnapshot = function(jsonData) {
      var release;
      release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.ParentId);
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

    function Project(id, title, shortName, descr, release) {
      this.id = id;
      this.title = title;
      this.shortName = shortName;
      this.descr = descr;
      this.release = release;
      this.resources = [];
      this.backlog = [];
      this.workload = [];
    }

    Project.create = function(jsonData, release) {
      var act, feature, project, res, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, release);
      _ref = jsonData.AssignedResources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        res = _ref[_i];
        project.resources.push(Assignment.create(res, null, project, release));
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

    Project.createSnapshot = function(jsonData) {
      var project;
      project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description);
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
      var act, json, status, _i, _len, _ref;
      act = Activity.create(jsonData.Activity);
      status = new ProjectActivityStatus(jsonData.HoursRemaining, act);
      _ref = jsonData.AssignedResources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        json = _ref[_i];
        status.assignedResources.push(Assignment.create(json, null, project, null));
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

  Meeting = (function(_super) {

    __extends(Meeting, _super);

    function Meeting(id, title, objective, descr, moment, date, time, releaseId) {
      this.id = id;
      this.title = title;
      this.objective = objective;
      this.descr = descr;
      this.moment = moment;
      this.date = date;
      this.time = time;
      this.releaseId = releaseId;
    }

    Meeting.create = function(jsonData) {
      var meeting;
      meeting = new Meeting(jsonData.Id, jsonData.Title, jsonData.Objective, jsonData.Description, jsonData.Moment, jsonData.Date, jsonData.Time);
      return meeting;
    };

    Meeting.createCollection = function(jsonData) {
      var meeting, meetings, _i, _len;
      meetings = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        meeting = jsonData[_i];
        this.meeting = Meeting.create(meeting);
        meetings.push(this.meeting);
      }
      return meetings;
    };

    return Meeting;

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

    Resource.prototype.addAssignment = function(assignment) {
      return this.assignments.push(assignment);
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
        res.addAssignment(Assignment.create(assignment, Resource.createSnapshot(jsonData)));
      }
      return res;
    };

    Resource.createSnapshot = function(jsonData) {
      var res;
      res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials);
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

  Assignment = (function(_super) {

    __extends(Assignment, _super);

    function Assignment(id, release, resource, project, focusFactor, startDate, endDate, activity, milestone, deliverable) {
      this.id = id;
      this.release = release;
      this.resource = resource;
      this.project = project;
      this.focusFactor = focusFactor;
      this.activity = activity;
      this.milestone = milestone;
      this.deliverable = deliverable;
      this.period = new Period(startDate, endDate, this.deliverable.title + ' ' + this.activity.title + ' ' + this.release.title + ' (' + this.focusFactor + ') ' + this.project.title);
    }

    Assignment.prototype.assignedHours = function() {
      var assHours;
      assHours = Math.round(this.focusFactor * this.period.workingHours());
      return assHours;
    };

    Assignment.prototype.remainingAssignedHours = function() {
      var assHours;
      assHours = Math.round(this.focusFactor * this.period.remainingWorkingHours());
      return assHours;
    };

    Assignment.prototype.resourceAvailableHours = function() {
      var available, hoursPresent;
      hoursPresent = this.resource.hoursAvailable(this.period);
      available = Math.round(hoursPresent * this.focusFactor);
      return available;
    };

    Assignment.create = function(jsonData, resource, project, release) {
      var activity, ass, deliverable, milestone;
      if (typeof resource === "undefined" || resource === null) {
        resource = Resource.create(jsonData.Resource);
      }
      if (typeof release === "undefined" || release === null) {
        release = Release.createSnapshot(jsonData.Phase);
      }
      if (typeof project === "undefined" || project === null) {
        project = Project.createSnapshot(jsonData.Project);
      }
      milestone = Milestone.create(jsonData.Milestone);
      deliverable = Deliverable.create(jsonData.Deliverable);
      activity = Activity.create(jsonData.Activity);
      ass = new Assignment(jsonData.Id, release, resource, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), activity, milestone, deliverable);
      return ass;
    };

    Assignment.createCollection = function(jsonData, resource, project, release) {
      var assignment, assignments, _i, _len;
      assignments = [];
      for (_i = 0, _len = jsonData.length; _i < _len; _i++) {
        assignment = jsonData[_i];
        this.assignment = Assignment.create(assignment, resource, project, release);
        assignments.push(this.assignment);
      }
      return assignments;
    };

    return Assignment;

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

  root.Meeting = Meeting;

  root.Deliverable = Deliverable;

  root.Activity = Activity;

  root.Assignment = Assignment;

  root.ProjectActivityStatus = ProjectActivityStatus;

  root.ReleaseAssignments = ReleaseAssignments;

  root.Environment = Environment;

  root.Version = Version;

  root.Process = Process;

}).call(this);
