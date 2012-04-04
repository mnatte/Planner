(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases) {
      this.saveSelected = __bind(this.saveSelected, this);
      this.selectRelease = __bind(this.selectRelease, this);      Release.extend(RCrud);
      this.selectedRelease = ko.observable();
      this.allReleases = ko.observableArray(allReleases);
      console.log(this.allReleases);
      Array.prototype.remove = function(e) {
        var t, _ref;
        if ((t = this.indexOf(e)) > -1) {
          return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
        }
      };
    }

    AdminReleaseViewmodel.prototype.selectRelease = function(data) {
      console.log("selectRelease - function");
      this.selectedRelease(data);
      return console.log("selectRelease after selection: " + this.selectedRelease().title);
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      console.log("clear: selectedRelease: " + (this.selectedRelease().title));
      return this.selectRelease(new Release(0, new Date(), new Date(), "", ""));
    };

    AdminReleaseViewmodel.prototype.saveSelected = function() {
      var a, rel,
        _this = this;
      rel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedRelease().id) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      this.allReleases.remove(rel);
      return this.selectedRelease().save("/planner/Release/Save", ko.toJSON(this.selectedRelease()), function(data) {
        return _this.allReleases.push(new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath));
      });
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
