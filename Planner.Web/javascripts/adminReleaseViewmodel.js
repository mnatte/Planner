(function() {
  var AdminReleaseViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminReleaseViewmodel = (function() {

    function AdminReleaseViewmodel(allReleases) {
      this.deleteRelease = __bind(this.deleteRelease, this);
      this.saveSelected = __bind(this.saveSelected, this);
      this.addPhase = __bind(this.addPhase, this);
      this.refreshRelease = __bind(this.refreshRelease, this);
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

    AdminReleaseViewmodel.prototype.refreshRelease = function(oldElement, jsonData) {
      var a, i, parentrel, phase, rel, _i, _len, _ref;
      rel = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.allReleases();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          if (a.id === oldElement.id) _results.push(a);
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
          if (a.id === oldElement.parentId) _results.push(a);
        }
        return _results;
      }).call(this))[0];
      console.log(parentrel);
      this.allReleases.remove(rel);
      this.allReleases.remove(parentrel);
      if (jsonData === !null && jsonData === !void 0) {
        i = this.allReleases().indexOf(rel) === -1 ? this.allReleases().indexOf(parentrel) : this.allReleases().indexOf(rel);
        rel = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath);
        _ref = jsonData.Phases;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          phase = _ref[_i];
          rel.addPhase(new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id));
        }
        return this.allReleases.splice(i, 0, rel);
      }
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
      var _this = this;
      console.log("saveSelected: selectedRelease: " + (this.selectedRelease()));
      console.log(ko.toJSON(this.selectedRelease()));
      return this.selectedRelease().save("/planner/Release/Save", ko.toJSON(this.selectedRelease()), function(data) {
        return _this.refreshRelease(_this.selectedRelease(), data);
      });
    };

    AdminReleaseViewmodel.prototype.deleteRelease = function(data) {
      var a, parentrel, refreshId, rel,
        _this = this;
      console.log("deleteRelease: " + data.id);
      if (data.parentId === void 0) {
        rel = ((function() {
          var _i, _len, _ref, _results;
          _ref = this.allReleases();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.id) _results.push(a);
          }
          return _results;
        }).call(this))[0];
        refreshId = data.id;
      } else {
        parentrel = ((function() {
          var _i, _len, _ref, _results;
          _ref = this.allReleases();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.parentId) _results.push(a);
          }
          return _results;
        }).call(this))[0];
        rel = ((function() {
          var _i, _len, _ref, _results;
          _ref = parentrel.phases;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            a = _ref[_i];
            if (a.id === data.id) _results.push(a);
          }
          return _results;
        })())[0];
        refreshId = data.parentId;
      }
      console.log("rel: " + rel);
      return rel["delete"]("/planner/Release/Delete/" + rel.id, function(callbackdata) {
        console.log(callbackdata);
        return rel.get("/planner/Release/GetReleaseSummaryById/" + refreshId, function(jsonData) {
          return _this.refreshRelease(rel, jsonData);
        });
      });
    };

    return AdminReleaseViewmodel;

  })();

  root.AdminReleaseViewmodel = AdminReleaseViewmodel;

}).call(this);
