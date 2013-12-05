(function() {
  var AbsencesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AbsencesViewmodel = (function() {

    function AbsencesViewmodel(allResources) {
      var _this = this;
      this.allResources = allResources;
      this.createVisualCuesForAbsences = __bind(this.createVisualCuesForAbsences, this);
      this.refreshTimeline = __bind(this.refreshTimeline, this);
      this.newAbsence = __bind(this.newAbsence, this);
      Period.extend(RCrud);
      Period.extend(RPeriodSerialize);
      Resource.extend(RTeamMember);
      this.selectedTimelineItem = ko.observable();
      this.selectedAbsence = ko.observable();
      this.dialogAbsences = ko.observable();
      this.selectedTimelineItem.subscribe(function(newValue) {
        return _this.selectedAbsence(newValue.dataObject);
      });
      this.selectedAbsence.subscribe(function(newValue) {
        var callback, uc;
        callback = function(data) {
          return _this.refreshTimeline(data);
        };
        uc = new UModifyAbsences(_this.selectedAbsence, _this.allResources, callback, _this.dialogAbsences);
        return uc.execute();
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

    AbsencesViewmodel.prototype.newAbsence = function() {
      var newAbsence;
      newAbsence = new Period(new Date(), new Date(), 'New Absence', 0);
      newAbsence.id = 0;
      return this.selectedAbsence(newAbsence);
    };

    AbsencesViewmodel.prototype.refreshTimeline = function(newItem) {
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
      } else {
        this.showAbsences.splice(index, 1);
      }
      timeline = new Mnd.Timeline(this.showAbsences, this.selectedTimelineItem);
      timeline.draw();
      return this.dialogAbsences(null);
    };

    AbsencesViewmodel.prototype.createVisualCuesForAbsences = function(data) {
      var uc,
        _this = this;
      uc = new UCreateVisualCuesForAbsences(30, function(data) {
        return console.log('callback succesful: ' + data);
      });
      return uc.execute();
    };

    return AbsencesViewmodel;

  })();

  root.AbsencesViewmodel = AbsencesViewmodel;

}).call(this);
