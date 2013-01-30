(function() {
  var AbsencesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AbsencesViewmodel = (function() {

    function AbsencesViewmodel(allResources) {
      var _this = this;
      this.allResources = allResources;
      this.newAbsence = __bind(this.newAbsence, this);
      this.deleteSelectedAbsence = __bind(this.deleteSelectedAbsence, this);
      this.saveSelectedAbsence = __bind(this.saveSelectedAbsence, this);
      this.refreshTimeline = __bind(this.refreshTimeline, this);
      this.closeDetails = __bind(this.closeDetails, this);
      this.setAssignments = __bind(this.setAssignments, this);
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

    AbsencesViewmodel.prototype.load = function(data) {
      var absence, dto, obj, resource, _i, _j, _len, _len2, _ref;
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
      var absence, p, timeline, timelineItem, _i, _len, _ref;
      console.log("refreshTimeline");
      absence = Period.create(newItem);
      _ref = this.allResources;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        if (p.id === newItem.Person.Id) absence.person = p;
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
        this.showAbsences.splice(index, 1, timelineItem);
      } else {
        this.showAbsences.splice(index, 0, timelineItem);
      }
      this.selectedTimelineItem(timelineItem);
      timeline = new Mnd.Timeline(this.showAbsences, this.selectedTimelineItem);
      return timeline.draw();
    };

    AbsencesViewmodel.prototype.saveSelectedAbsence = function() {
      var a, absence, i, timelineItem, _i, _len, _ref,
        _this = this;
      i = -1;
      absence = this.selectedAbsence();
      if (this.selectedAbsence().id > 0) {
        _ref = this.displayData;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.dataObject === this.selectedAbsence()) timelineItem = a;
        }
        i = this.displayData.indexOf(timelineItem);
        absence.personId = absence.person.id;
        delete absence.person;
      } else {
        absence.personId = this.selectedResource().id;
      }
      console.log(ko.toJSON(absence));
      return this.selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(absence), function(data) {
        return _this.refreshTimeline(i, data);
      });
    };

    AbsencesViewmodel.prototype.deleteSelectedAbsence = function() {
      var a, abs, i,
        _this = this;
      console.log(this.selectedAbsence());
      abs = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.showAbsences;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.dataObject.id === this.selectedAbsence().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      i = this.showAbsences.indexOf(abs);
      console.log('index: ' + i);
      return this.selectedAbsence()["delete"]("/planner/Resource/DeleteAbsence/" + this.selectedAbsence().id, function(callbackdata) {
        var next;
        console.log(callbackdata);
        _this.showAbsences.splice(i, 1);
        next = _this.showAbsences[i];
        console.log(next);
        _this.selectedTimelineItem(next);
        return $.unblockUI();
      });
    };

    AbsencesViewmodel.prototype.newAbsence = function() {
      var newAbsence;
      newAbsence = new Period(new Date(), new Date(), 'New Absence', 0);
      newAbsence.id = 0;
      this.selectedAbsence(newAbsence);
      return console.log(this.selectedAbsence());
    };

    return AbsencesViewmodel;

  })();

  root.AbsencesViewmodel = AbsencesViewmodel;

}).call(this);
