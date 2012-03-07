(function() {
  var UDisplayReleaseStatus, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  UDisplayReleaseStatus = (function() {

    function UDisplayReleaseStatus() {
      Release.extend(RGroupBy);
    }

    UDisplayReleaseStatus.prototype.execute = function(data) {
      var feat, ft, phase, set, statusData, statusgroup, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _m, _ref, _ref2, _ref3, _ref4, _ref5;
      this.release = new Release(DateFormatter.formatJsonDate(data.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(data.EndDate, "dd/MM/yyyy"), data.WorkingDays, data.Title);
      _ref = data.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        this.release.addPhase(new Phase(DateFormatter.formatJsonDate(phase.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(phase.EndDate, "dd/MM/yyyy"), phase.WorkingDays, phase.Title));
      }
      _ref2 = data.Backlog;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        feat = _ref2[_j];
        this.release.addFeature(new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project, feat.RemainingHours, feat.Title, feat.Status));
      }
      this.release.group('project', this.release.backlog);
      this.release.group('state', this.release.backlog);
      _ref3 = this.release.sets;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        set = _ref3[_k];
        if (!(set.groupedBy === "project")) continue;
        set.link = "#" + set.label;
        set.totalHours = 0;
        _ref4 = set.items;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          ft = _ref4[_l];
          set.totalHours += ft.remainingHours;
        }
      }
      statusData = [];
      _ref5 = this.release.sets;
      for (_m = 0, _len5 = _ref5.length; _m < _len5; _m++) {
        statusgroup = _ref5[_m];
        if (!(statusgroup.groupedBy === "state")) continue;
        data = [];
        data.push(statusgroup.label);
        data.push(statusgroup.items.length);
        statusData.push(data);
      }
      ko.applyBindings(this.release);
      return showStatusChart(statusData);
    };

    return UDisplayReleaseStatus;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

}).call(this);
