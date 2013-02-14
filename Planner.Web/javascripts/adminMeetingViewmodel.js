(function() {
  var AdminMeetingViewmodel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  AdminMeetingViewmodel = (function(_super) {

    __extends(AdminMeetingViewmodel, _super);

    function AdminMeetingViewmodel(allMeetings) {
      this.scheduleMeeting = __bind(this.scheduleMeeting, this);
      this.createNewEmptyItem = __bind(this.createNewEmptyItem, this);
      this.createNewItem = __bind(this.createNewItem, this);      Meeting.extend(RSimpleCrud);
      Meeting.extend(RScheduleItem);
      Meeting.setSaveUrl("/planner/Meeting/Save");
      Meeting.setDeleteUrl("/planner/Meeting/Delete");
      Meeting.setScheduleUrl("/planner/Meeting/Schedule");
      this.date = ko.observable();
      this.time = ko.observable();
      this.releaseId = ko.observable();
      AdminMeetingViewmodel.__super__.constructor.apply(this, arguments);
    }

    AdminMeetingViewmodel.prototype.createNewItem = function(jsonData) {
      return new Meeting(jsonData.Id, jsonData.Title, jsonData.Objective, jsonData.Description, jsonData.Moment);
    };

    AdminMeetingViewmodel.prototype.createNewEmptyItem = function() {
      return new Meeting(0, "", "", "", "");
    };

    AdminMeetingViewmodel.prototype.scheduleMeeting = function() {
      var _this = this;
      return this.selectedItem().schedule(this.selectedItem().id, this.releaseId(), this.date(), this.time(), function(data) {
        return _this.refreshItem(i, data);
      });
    };

    return AdminMeetingViewmodel;

  })(SimpleCrudViewmodel);

  root.AdminMeetingViewmodel = AdminMeetingViewmodel;

}).call(this);
