(function() {
  var MileStone, Mixin, Phase, Release, moduleKeywords, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  moduleKeywords = ['extended', 'included'];

  Mixin = (function() {

    function Mixin() {}

    Mixin.extend = function(obj) {
      var key, value, _ref;
      for (key in obj) {
        value = obj[key];
        if (__indexOf.call(moduleKeywords, key) < 0) this[key] = value;
      }
      if ((_ref = obj.extended) != null) _ref.apply(this);
      return this;
    };

    Mixin.include = function(obj) {
      var key, value, _ref;
      for (key in obj) {
        value = obj[key];
        if (__indexOf.call(moduleKeywords, key) < 0) this.prototype[key] = value;
      }
      if ((_ref = obj.included) != null) _ref.apply(this);
      return this;
    };

    return Mixin;

  })();

  Phase = (function(_super) {

    __extends(Phase, _super);

    function Phase(startDate, endDate, workingDays, title) {
      this.startDate = startDate;
      this.endDate = endDate;
      this.workingDays = workingDays;
      this.title = title;
      this.workingHours = this.workingDays * 8;
    }

    return Phase;

  })(Mixin);

  MileStone = (function() {

    function MileStone(date, title) {
      this.date = date;
      this.title = title;
    }

    return MileStone;

  })();

  Release = (function(_super) {

    __extends(Release, _super);

    function Release(startDate, endDate, workingDays, title) {
      this.startDate = startDate;
      this.endDate = endDate;
      this.workingDays = workingDays;
      this.title = title;
      Release.__super__.constructor.apply(this, arguments);
      this.phases = [];
    }

    Release.prototype.addPhase = function(phase) {
      return this.phases.push(phase);
    };

    return Release;

  })(Phase);

  root.Phase = Phase;

  root.MileStone = MileStone;

  root.Release = Release;

}).call(this);
