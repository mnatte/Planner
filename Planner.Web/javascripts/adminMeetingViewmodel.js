(function() {
  var AdminMeetingViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminMeetingViewmodel = (function(_super) {

    __extends(AdminMeetingViewmodel, _super);

    function AdminMeetingViewmodel(allMeetings) {
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Meeting.extend(RSimpleCrud);
      Meeting.setSaveUrl("/planner/Meeting/Save");
      Meeting.setDeleteUrl("/planner/Meeting/Delete");
      AdminMeetingViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminMeetingViewmodel.prototype.createNewItem = function(jsonData) {
      return new Meeting(jsonData.Id, jsonData.Title, jsonData.Objective, jsonData.Description, jsonData.Moment);
    };

    AdminMeetingViewmodel.prototype.createNewEmptyItem = function() {
      return new Meeting(0, "", "", "", "");
    };

    return AdminMeetingViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminMeetingViewmodel = AdminMeetingViewmodel;

}).call(this);
