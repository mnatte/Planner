(function() {
  var AssignmentsViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AssignmentsViewmodel = (function() {

    function AssignmentsViewmodel(allResources) {
      this.afterMail = __bind(this.afterMail, this);
      this.updatePeriod = __bind(this.updatePeriod, this);
      var weekLater,
        _this = this;
      Period.extend(RCrud);
      Period.extend(RPeriodSerialize);
      Resource.extend(RTeamMember);
      this.selectedTimelineItem = ko.observable();
      this.selectedAbsence = ko.observable();
      this.selectedResource = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        console.log(newValue);
        _this.selectedAbsence(newValue.dataObject);
        return _this.selectedResource(newValue.dataObject.person);
      });
      this.selectedResource.subscribe(function(newValue) {
        return console.log('selectedResource changed: ' + newValue.fullName());
      });
      this.allResources = ko.observableArray(allResources);
      this.showResources = ko.observableArray(allResources);
      this.includeResources = ko.observableArray();
      this.includeResources.subscribe(function(newValue) {
        var include;
        console.log(newValue);
        include = newValue.reduce(function(acc, x) {
          var r, resource, _i, _len, _ref;
          _ref = _this.allResources();
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
      this.checkPeriod = ko.observable(new Period(new Date(), weekLater));
      this.checkPeriod.subscribe(function(newValue) {
        _this.load(_this.showResources().sort());
        return drawTimeline(_this.showAssignments, _this.selectedTimelineItem);
      });
      this.showResources.subscribe(function(newValue) {
        console.log('showResources changed: ' + newValue);
        _this.load(_this.showResources().sort());
        return drawTimeline(_this.showAssignments, _this.selectedTimelineItem);
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
            info: assignment.period.toString(),
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

    return AssignmentsViewmodel;

  })();

  root.AssignmentsViewmodel = AssignmentsViewmodel;

}).call(this);
