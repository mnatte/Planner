(function() {
  var DateFormatter, DatePlus, Mixin, moduleKeywords, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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

  DateFormatter = (function() {

    function DateFormatter() {}

    DateFormatter.formatJsonDate = function(dateJson, format) {
      console.log("formatJsonDate: " + dateJson + " with format " + format);
      return $.format.date(this.createJsDateFromJson(dateJson), format);
    };

    DateFormatter.createJsDateFromJson = function(dateJson) {
      return eval("new " + dateJson.slice(1, -1));
    };

    DateFormatter.formatJsDate = function(date, format) {
      return $.format.date(date, format);
    };

    DateFormatter.createFromString = function(string) {
      return new Date(getDateFromFormat(string, "dd/MM/yyyy"));
    };

    return DateFormatter;

  })();

  DatePlus = (function() {

    function DatePlus(date) {
      this.date = date;
      this.dateString = $.format.date(date, 'dd/MM/yyyy');
    }

    return DatePlus;

  })();

  root.Mixin = Mixin;

  root.DateFormatter = DateFormatter;

  root.DatePlus = DatePlus;

}).call(this);
