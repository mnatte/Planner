(function() {
  var AssignmentsViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AssignmentsViewmodel = (function() {

    function AssignmentsViewmodel(allResources) {
      var threeMonthsLater, weekLater,
        _this = this;
      this.allResources = allResources;
      this.refreshTimeline = __bind(this.refreshTimeline, this);
      this.afterMail = __bind(this.afterMail, this);
      this.updatePeriod = __bind(this.updatePeriod, this);
      Period.extend(RCrud);
      Period.extend(RPeriodSerialize);
      Resource.extend(RTeamMember);
      this.showResources = ko.observableArray(this.allResources);
      this.includeResources = ko.observableArray();
      this.selectedTimelineItem = ko.observable();
      this.selectedAbsence = ko.observable();
      this.dialogAbsences = ko.observable();
      this.selectedAssignment = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        console.log(newValue);
        if (newValue.dataObject.type() === "Period") {
          console.log("is Period");
          return _this.selectedAbsence(newValue.dataObject);
        }
      });
      this.selectedAbsence.subscribe(function(newValue) {
        var callback, uc;
        console.log(newValue);
        callback = function(data) {
          return _this.refreshTimeline(data);
        };
        uc = new UModifyAbsences(_this.selectedAbsence, _this.allResources, callback, _this.dialogAbsences);
        return uc.execute();
      });
      this.includeResources.subscribe(function(newValue) {
        var include;
        console.log(newValue);
        include = newValue.reduce(function(acc, x) {
          var r, resource, _i, _len, _ref;
          _ref = _this.allResources;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            r = _ref[_i];
            if (+r.id === +x) resource = r;
          }
          acc.push(resource);
          return acc;
        }, []);
        return _this.showResources(include);
      });
      weekLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 7);
      threeMonthsLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 90);
      this.checkPeriod = ko.observable(new Period(new Date(), threeMonthsLater));
      this.checkPeriod.subscribe(function(newValue) {
        var timeline;
        _this.load(_this.showResources().sort());
        timeline = new Mnd.Timeline(_this.showAssignments, _this.selectedTimelineItem);
        return timeline.draw();
      });
      this.showResources.subscribe(function(newValue) {
        var timeline;
        console.log('showResources changed: ' + newValue);
        _this.load(_this.showResources().sort());
        timeline = new Mnd.Timeline(_this.showAssignments, _this.selectedTimelineItem);
        return timeline.draw();
      });
    }

    AssignmentsViewmodel.prototype.load = function(data) {
      var abs, absence, ass, assignment, dto, i, obj, resource, _i, _j, _k, _len, _len2, _len3, _ref, _ref2;
      this.displayData = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        resource = data[_i];
        i = 0;
        _ref = (function() {
          var _k, _len2, _ref, _results;
          _ref = resource.periodsAway;
          _results = [];
          for (_k = 0, _len2 = _ref.length; _k < _len2; _k++) {
            abs = _ref[_k];
            if (abs.overlaps(this.checkPeriod())) _results.push(abs);
          }
          return _results;
        }).call(this);
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          absence = _ref[_j];
          dto = absence;
          dto.person = resource;
          obj = {
            group: resource.fullName() + '[' + i + ']',
            start: absence.startDate.date,
            end: absence.endDate.date,
            content: absence.title,
            info: absence.toString(),
            dataObject: dto
          };
          this.displayData.push(obj);
          i++;
        }
        _ref2 = (function() {
          var _l, _len3, _ref2, _results;
          _ref2 = resource.assignments;
          _results = [];
          for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
            ass = _ref2[_l];
            if (ass.period.overlaps(this.checkPeriod())) _results.push(ass);
          }
          return _results;
        }).call(this);
        for (_k = 0, _len3 = _ref2.length; _k < _len3; _k++) {
          assignment = _ref2[_k];
          dto = assignment;
          dto.person = resource;
          obj = {
            group: resource.fullName() + '[' + i + ']',
            start: assignment.period.startDate.date,
            end: assignment.period.endDate.date,
            content: assignment.period.title,
            info: assignment.period.toString() + '(' + assignment.remainingAssignedHours() + ' hrs remaining)',
            dataObject: dto
          };
          this.displayData.push(obj);
          i++;
        }
      }
      return this.showAssignments = this.displayData.sort(function(a, b) {
        return a.start - b.end;
      });
    };

    AssignmentsViewmodel.prototype.updatePeriod = function(data) {
      var period;
      period = new Period(DateFormatter.createFromString(this.checkPeriod().startDate.dateString), DateFormatter.createFromString(this.checkPeriod().endDate.dateString));
      return this.checkPeriod(period);
    };

    AssignmentsViewmodel.prototype.mailPlanning = function(model) {
      var ajx,
        _this = this;
      ajx = new Ajax;
      return ajx.mailPlanning("/planner/Resource/Assignments/Mail", ko.toJSON(this.checkPeriod()), function(data) {
        return _this.afterMail(data);
      });
    };

    AssignmentsViewmodel.prototype.afterMail = function(data) {
      return console.log(data);
    };

    AssignmentsViewmodel.prototype.refreshTimeline = function(newItem) {
      var a, absence, index, p, timeline, timelineItem, _i, _j, _len, _len2, _ref, _ref2;
      console.log("refreshTimeline");
      index = -1;
      if (this.selectedAbsence().id > 0) {
        _ref = this.displayData;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.dataObject === this.selectedAbsence()) timelineItem = a;
        }
        index = this.displayData.indexOf(timelineItem);
      }
      console.log(index);
      console.log(newItem);
      if (newItem.StartDate) {
        absence = Period.create(newItem);
        _ref2 = this.allResources;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          p = _ref2[_j];
          if (+p.id === +newItem.Person.Id) absence.person = p;
        }
        timelineItem = {
          group: absence.person.fullName(),
          start: absence.startDate.date,
          end: absence.endDate.date,
          content: absence.title,
          info: absence.toString(),
          dataObject: absence
        };
        console.log(timelineItem);
        if (index > -1) {
          this.showAssignments.splice(index, 1, timelineItem);
        } else {
          this.showAssignments.splice(index, 0, timelineItem);
        }
        this.selectedTimelineItem(timelineItem);
      } else {
        this.showAssignments.splice(index, 1);
      }
      timeline = new Mnd.Timeline(this.showAssignments, this.selectedTimelineItem);
      timeline.draw();
      return this.dialogAbsences(null);
    };

    return AssignmentsViewmodel;

  })();

  root.AssignmentsViewmodel = AssignmentsViewmodel;

}).call(this);
