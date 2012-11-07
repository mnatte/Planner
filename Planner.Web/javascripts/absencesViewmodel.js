(function() {
  var AbsencesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AbsencesViewmodel = (function() {

    function AbsencesViewmodel(allResources) {
      this.selectPhase = __bind(this.selectPhase, this);
      this.closeDetails = __bind(this.closeDetails, this);
      this.setAssignments = __bind(this.setAssignments, this);
    }

    AbsencesViewmodel.prototype.load = function(data) {
      var absence, obj, resource, _i, _j, _len, _len2, _ref;
      this.resources = [];
      this.displayData = [];
      console.log(data);
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        resource = data[_i];
        console.log(resource.fullName());
        _ref = resource.periodsAway;
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          absence = _ref[_j];
          obj = {
            group: resource.fullName(),
            start: absence.startDate.date,
            end: absence.endDate.date,
            content: absence.title,
            info: absence.toString()
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

    AbsencesViewmodel.prototype.selectPhase = function(data) {
      this.selectedPhase(data);
      return this.canShowDetails(true);
    };

    return AbsencesViewmodel;

  })();

  root.AbsencesViewmodel = AbsencesViewmodel;

}).call(this);
