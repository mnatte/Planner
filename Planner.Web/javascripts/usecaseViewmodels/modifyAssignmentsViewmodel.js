(function() {
  var ModifyAssignmentsViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ModifyAssignmentsViewmodel = (function() {

    function ModifyAssignmentsViewmodel(selectedAssignment, allResources, afterSubmitCallback) {
      var p, _i, _len, _ref;
      this.selectedAssignment = selectedAssignment;
      this.allResources = allResources;
      this.afterSubmitCallback = afterSubmitCallback;
      this.deleteSelectedAssignment = __bind(this.deleteSelectedAssignment, this);
      this.saveSelectedAssignment = __bind(this.saveSelectedAssignment, this);
      console.log('ModifyAssignmentsViewmodel instantiated');
      console.log(this.selectedAssignment());
      Period.extend(RCrud);
      Period.extend(RPeriodSerialize);
      Resource.extend(RTeamMember);
      if (this.selectedAssignment().resource) {
        _ref = this.allResources;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          if (p.id === this.selectedAssignment().resource.id) {
            this.selectedPerson = p;
          }
        }
        console.log(this.selectedPerson);
      }
      this.selectedResource = ko.observable(this.selectedPerson);
    }

    ModifyAssignmentsViewmodel.prototype.saveSelectedAssignment = function() {
      var assignment;
      console.log('saveSelectedAssignment');
      assignment = this.selectedAssignment();
      console.log(ko.toJSON(assignment));
      return this.selectedAssignment().resource.plan(assignment.release, assignment.project, assignment.milestone, assignment.deliverable, assignment.activity, assignment.period, assignment.focusFactor, this.afterSubmitCallback);
    };

    ModifyAssignmentsViewmodel.prototype.deleteSelectedAssignment = function() {
      return console.log(this.selectedAssignment());
    };

    return ModifyAssignmentsViewmodel;

  })();

  root.ModifyAssignmentsViewmodel = ModifyAssignmentsViewmodel;

}).call(this);
