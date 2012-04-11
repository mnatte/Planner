(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases) {
      this.saveSelected = __bind(this.saveSelected, this);
      this.addPhase = __bind(this.addPhase, this);
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
      return console.log("selectRelease after selection: " + this.selectedRelease().title + ", parentId: " + this.selectedRelease().parentId);
    };

    AdminReleaseViewmodel.prototype.clear = function() {
      console.log("clear: selectedRelease: " + (this.selectedRelease().title));
      return this.selectRelease(new Release(0, new Date(), new Date(), "", ""));
    };

    AdminReleaseViewmodel.prototype.addPhase = function(data) {
      this.selectRelease(new Release(0, new Date(), new Date(), "", "", data.id));
      return console.log("selectedRelease parentId: " + (this.selectedRelease().parentId));
    };

    AdminReleaseViewmodel.prototype.saveSelected = function() {
      var a, parentrel, rel,
        _this = this;
      console.log("saveSelected: selectedRelease: " + (this.selectedRelease()));
      console.log(ko.toJSON(this.selectedRelease()));
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
      console.log(rel);
      parentrel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === this.selectedRelease().parentId) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      console.log(parentrel);
      this.allReleases.remove(rel);
      this.allReleases.remove(parentrel);
      return this.selectedRelease().save("/planner/Release/Save", ko.toJSON(this.selectedRelease()), function(data) {
        var phase, _i, _len, _ref;
        rel = new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath);
        _ref = data.Phases;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          phase = _ref[_i];
          rel.addPhase(new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id));
        }
        return _this.allReleases.push(rel);
      });
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
