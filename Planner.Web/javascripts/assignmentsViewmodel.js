(function() {
  var AssignmentsViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AssignmentsViewmodel = (function() {

    function AssignmentsViewmodel(allResources) {
      var _this = this;
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
    }

    AssignmentsViewmodel.prototype.load = function(data) {
      var absence, assignment, dto, obj, resource, _i, _j, _k, _len, _len2, _len3, _ref, _ref2;
      this.displayData = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        resource = data[_i];
        _ref = resource.periodsAway;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          absence = _ref[_j];
          dto = absence;
          dto.person = resource;
          obj = {
            group: resource.fullName(),
            start: absence.startDate.date,
            end: absence.endDate.date,
            content: absence.title,
            info: absence.toString(),
            dataObject: dto
          };
          this.displayData.push(obj);
        }
        _ref2 = resource.assignments;
        for (_k = 0, _len3 = _ref2.length; _k < _len3; _k++) {
          assignment = _ref2[_k];
          dto = assignment;
          dto.person = resource;
          obj = {
            group: resource.fullName(),
            start: assignment.period.startDate.date,
            end: assignment.period.endDate.date,
            content: assignment.period.title,
            info: assignment.period.toString(),
            dataObject: dto
          };
          this.displayData.push(obj);
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
      return ajx.mailPlanning("/planner/Resource/Assignments/Mail", ko.toJSON({
        startDate: "30/11/2012",
        endDate: "07/12/2012"
      }), function(data) {
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
