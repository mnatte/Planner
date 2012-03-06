(function() {
  var UDisplayReleaseStatus, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  UDisplayReleaseStatus = (function() {

    function UDisplayReleaseStatus() {
      Release.extend(RGroupBy);
    }

    UDisplayReleaseStatus.prototype.execute = function(data) {
      var feat, phase, _i, _j, _len, _len2, _ref, _ref2;
      console.log(data.Title);
      this.release = new Release(DateFormatter.formatJsonDate(data.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(data.EndDate, "dd/MM/yyyy"), data.WorkingDays, data.Title);
      _ref = data.Phases;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        phase = _ref[_i];
        this.release.addPhase(new Phase(DateFormatter.formatJsonDate(phase.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(phase.EndDate, "dd/MM/yyyy"), phase.WorkingDays, phase.Title));
      }
      _ref2 = data.Backlog;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        feat = _ref2[_j];
        this.release.addFeature(new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project, feat.RemainingHours, feat.Title));
      }
      this.release.group('project', this.release.backlog);
      console.log(this.release.sets.length);
      ko.applyBindings(this.release);
      $("#tabSection > ul > li > a").first().addClass("active");
      return $(".tabs-content > li").first().addClass("active");
    };

    return UDisplayReleaseStatus;

  })();

  root.UDisplayReleaseStatus = UDisplayReleaseStatus;

}).call(this);
