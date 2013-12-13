(function() {
  var ModifyAbsencesViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ModifyAbsencesViewmodel = (function() {

    function ModifyAbsencesViewmodel(selectedAbsence, allResources, afterSubmitCallback) {
      var p, _i, _len, _ref;
      this.selectedAbsence = selectedAbsence;
      this.allResources = allResources;
      this.afterSubmitCallback = afterSubmitCallback;
      this.deleteSelectedAbsence = __bind(this.deleteSelectedAbsence, this);
      this.saveSelectedAbsence = __bind(this.saveSelectedAbsence, this);
      console.log('ModifyAbsencesViewmodel instantiated');
      console.log(this.selectedAbsence);
      Period.extend(RCrud);
      Period.extend(RPeriodSerialize);
      Resource.extend(RTeamMember);
      if (this.selectedAbsence().person) {
        _ref = this.allResources;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          if (p.id === this.selectedAbsence().person.id) this.selectedPerson = p;
        }
        console.log(this.selectedPerson);
      }
      this.selectedResource = ko.observable(this.selectedPerson);
    }

    ModifyAbsencesViewmodel.prototype.saveSelectedAbsence = function() {
      var absence;
      absence = this.selectedAbsence();
      if (this.selectedAbsence().id > 0) {
        absence.personId = absence.person.id;
        delete absence.person;
      } else {
        absence.personId = this.selectedResource().id;
      }
      console.log(ko.toJSON(absence));
      return this.selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(absence), this.afterSubmitCallback);
    };

    ModifyAbsencesViewmodel.prototype.deleteSelectedAbsence = function() {
      console.log(this.selectedAbsence());
      return this.selectedAbsence()["delete"]("/planner/Resource/DeleteAbsence/" + this.selectedAbsence().id, this.afterSubmitCallback);
    };

    return ModifyAbsencesViewmodel;

  })();

  root.ModifyAbsencesViewmodel = ModifyAbsencesViewmodel;

}).call(this);
