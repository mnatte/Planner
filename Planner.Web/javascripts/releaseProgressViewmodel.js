(function() {
  var ReleaseProgressViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  ReleaseProgressViewmodel = (function() {

    function ReleaseProgressViewmodel(allReleases) {
      this.allReleases = allReleases;
      this.viewReleaseProgress = __bind(this.viewReleaseProgress, this);
    }

    ReleaseProgressViewmodel.prototype.viewReleaseProgress = function(selectedRelease) {
      var ajax, uc;
      console.log(selectedRelease);
      uc = new UDisplayReleaseProgress(selectedRelease.title);
      ajax = new Ajax();
      return ajax.getReleaseProgress(selectedRelease.id, function(data) {
        return uc.execute(data);
      });
    };

    return ReleaseProgressViewmodel;

  })();

  root.ReleaseProgressViewmodel = ReleaseProgressViewmodel;

}).call(this);
