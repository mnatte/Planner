(function() {
  var ProcessPerformanceViewmodel, root;

  root = typeof global !== "undefined" && global !== null ? global : window;

  ProcessPerformanceViewmodel = (function() {

    function ProcessPerformanceViewmodel() {
      this.selectedMilestone = ko.observable();
      this.velocity = ko.observable();
    }

    return ProcessPerformanceViewmodel;

  })();

  root.ProcessPerformanceViewmodel = ProcessPerformanceViewmodel;

}).call(this);
