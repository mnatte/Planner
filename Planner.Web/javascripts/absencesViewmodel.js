(function() {
  var AbsencesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AbsencesViewmodel = (function() {

    function AbsencesViewmodel(allResources) {
      this.saveSelectedAbsence = __bind(this.saveSelectedAbsence, this);
      this.refreshTimeline = __bind(this.refreshTimeline, this);
      this.closeDetails = __bind(this.closeDetails, this);
      this.setAssignments = __bind(this.setAssignments, this);
      var _this = this;
      Period.extend(RCrud);
      Period.extend(RPeriodSerialize);
      Resource.extend(RTeamMember);
      this.selectedTimelineItem = ko.observable();
      this.selectedAbsence = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        console.log(newValue);
        return _this.selectedAbsence(newValue.dataObject);
      });
    }

    AbsencesViewmodel.prototype.load = function(data) {
      var absence, dto, obj, resource, _i, _j, _len, _len2, _ref;
      this.displayData = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        resource = data[_i];
        _ref = resource.periodsAway;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          absence = _ref[_j];
          dto = absence;
          dto.personId = resource.id;
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
      }
      return this.showAbsences = this.displayData.sort(function(a, b) {
        return a.start - b.end;
      });
    };

    AbsencesViewmodel.prototype.setAssignments = function(jsonData) {
      this.assignments.removeAll();
      return this.assignments(AssignedResource.createCollection(jsonData));
    };

    AbsencesViewmodel.prototype.loadAssignments = function(releaseId) {
      var ajax;
      ajax = new Ajax();
      return ajax.getAssignedResourcesForRelease(releaseId, this.setAssignments);
    };

    AbsencesViewmodel.prototype.closeDetails = function() {
      return this.canShowDetails(false);
    };

    AbsencesViewmodel.prototype.refreshTimeline = function(index, newItem) {
      var absence, person, timelineItem;
      console.log("refreshTimeline");
      absence = Period.create(newItem);
      person = Resource.createSnapshot(newItem.Person);
      timelineItem = {
        group: person.fullName(),
        start: absence.startDate.date,
        end: absence.endDate.date,
        content: absence.title,
        info: absence.toString(),
        dataObject: absence
      };
      console.log(timelineItem);
      this.showAbsences.splice(index, 1, timelineItem);
      timeline.redraw;
      return this.selectedTimelineItem(timelineItem);
    };

    AbsencesViewmodel.prototype.saveSelectedAbsence = function() {
      var a, i, timelineItem, _i, _len, _ref,
        _this = this;
      console.log(ko.toJSON(this.selectedAbsence()));
      _ref = this.displayData;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        a = _ref[_i];
        if (a.dataObject === this.selectedAbsence()) timelineItem = a;
      }
      i = this.displayData.indexOf(timelineItem);
      return this.selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(this.selectedAbsence()), function(data) {
        return _this.refreshTimeline(i, data);
      });
    };

    return AbsencesViewmodel;

  })();

  root.AbsencesViewmodel = AbsencesViewmodel;

}).call(this);
