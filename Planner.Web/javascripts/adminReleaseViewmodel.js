(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases) {
      this.allReleases = allReleases;
      this.saveSelected = __bind(this.saveSelected, this);
      this.selectRelease = __bind(this.selectRelease, this);
      Release.extend(RCrud);
      console.log(this.allReleases);
      this.selectedRelease = ko.observable();
    }

    AdminReleaseViewmodel.prototype.selectRelease = function(data) {
      console.log("selectRelease - function");
      this.selectedRelease(data);
      return console.log("selectRelease after selection: " + this.selectedRelease().title);
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      console.log("clear: selectedRelease: " + (this.selectedRelease().title));
      return this.selectRelease(new Release("", "", "", ""));
    };

    AdminReleaseViewmodel.prototype.saveSelected = function() {
      console.log("saveSelected: selectedRelease: " + (this.selectedRelease()));
      return console.log(ko.toJSON(this.selectedRelease()));
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
