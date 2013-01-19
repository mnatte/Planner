(function() {
  var AssignmentsViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AssignmentsViewmodel = (function() {

    function AssignmentsViewmodel(allResources) {
      var weekLater,
        _this = this;
      this.allResources = allResources;
      this.afterMail = __bind(this.afterMail, this);
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
      weekLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 7);
      this.checkPeriod = ko.observable(new Period(new Date(), weekLater));
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
