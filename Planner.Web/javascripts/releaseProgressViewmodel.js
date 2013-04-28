(function() {
  var ReleaseProgressViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseProgressViewmodel = (function() {

    function ReleaseProgressViewmodel(allReleases) {
      this.allReleases = allReleases;
      this.viewReleaseProgress = __bind(this.viewReleaseProgress, this);
      this.selectPhase = __bind(this.selectPhase, this);
      this.selectedPhase = ko.observable();
      this.selectedMilestone = ko.observable();
    }

    ReleaseProgressViewmodel.prototype.selectPhase = function(data) {
      console.log("selectPhase - function");
      this.selectedPhase(data);
      console.log(this.selectedPhase.milestones);
      return this.selectedMilestone(null);
    };

    ReleaseProgressViewmodel.prototype.viewReleaseProgress = function(milestone) {
      var ajax, uc, uc2;
      console.log(milestone);
      this.selectedMilestone(milestone);
      uc = new UDisplayReleaseProgress(this.selectedMilestone().phaseTitle, 'graph1');
      uc2 = new UDisplayBurndown(this.selectedMilestone().phaseTitle + ' - ' + this.selectedMilestone().title, 'graph0');
      ajax = new Ajax();
      return ajax.getReleaseProgress(this.selectedMilestone().phaseId, this.selectedMilestone().id, function(data) {
        uc.execute(data.Progress);
        return uc2.execute(data.Burndown);
      });
    };

    return ReleaseProgressViewmodel;

  })();

  root.ReleaseProgressViewmodel = ReleaseProgressViewmodel;

}).call(this);
