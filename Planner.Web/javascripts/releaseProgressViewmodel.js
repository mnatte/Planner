(function() {
  var ReleaseProgressViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseProgressViewmodel = (function() {

    function ReleaseProgressViewmodel(allReleases) {
      this.allReleases = allReleases;
      this.viewReleaseProgress = __bind(this.viewReleaseProgress, this);
      this.selectedRelease = ko.observable();
    }

    ReleaseProgressViewmodel.prototype.viewReleaseProgress = function(release) {
      var ajax, uc;
      console.log(release);
      this.selectedRelease(release);
      uc = new UDisplayReleaseProgress(this.selectedRelease().title);
      ajax = new Ajax();
      return ajax.getReleaseProgress(this.selectedRelease().id, function(data) {
        return uc.execute(data);
      });
    };

    return ReleaseProgressViewmodel;

  })();

  root.ReleaseProgressViewmodel = ReleaseProgressViewmodel;

}).call(this);
