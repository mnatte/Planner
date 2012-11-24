(function() {
  var RCrud, RGroupBy, RMoveItem, RSimpleCrud, RTeamMember, root,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    _this = this;

  root = typeof global !== "undefined" && global !== null ? global : window;

  RMoveItem = {
    move: function(source, target) {
      source.splice(source.indexOf(this), 1);
      return target.push(this);
    },
    extended: function() {
      return this.include({
        test: "extended with RMoveItem"
      });
    }
  };

  RGroupBy = {
    extended: function() {
      return this.include({
        sets: [],
        group: function(property, collection) {
          var addedSets, grp, item, set, _i, _len, _ref;
          addedSets = [];
          for (_i = 0, _len = collection.length; _i < _len; _i++) {
            item = collection[_i];
            if (_ref = "" + property + "_" + item[property], __indexOf.call(addedSets, _ref) < 0) {
              this.sets.push({
                label: item[property],
                items: [],
                groupedBy: property
              });
              addedSets.push("" + property + "_" + item[property]);
            }
            set = ((function() {
              var _j, _len2, _ref2, _results;
              _ref2 = this.sets;
              _results = [];
              for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
                grp = _ref2[_j];
                if (grp.label === item[property] && grp.groupedBy === property) {
                  _results.push(grp);
                }
              }
              return _results;
            }).call(this))[0];
            set.items.push(item);
          }
          return this.sets;
        }
      });
    }
  };

  RTeamMember = {
    createSnapshot: function(jsonData) {
      var res;
      res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber);
      return res;
    },
    extended: function() {
      return this.include({
        focusFactor: 0.8,
        roles: [],
        hoursPlannedIn: function(period) {
          var ass, assignment, hrsPlannedIn, overlappingAssignments;
          hrsPlannedIn = 0;
          overlappingAssignments = (function() {
            var _i, _len, _ref, _results;
            _ref = this.assignments;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              ass = _ref[_i];
              if (ass.period.overlaps(period)) _results.push(ass);
            }
            return _results;
          }).call(this);
          if ((overlappingAssignments != null) && typeof overlappingAssignments !== 'undefined' && overlappingAssignments.length > 0) {
            hrsPlannedIn = ((function() {
              var _i, _len, _results;
              _results = [];
              for (_i = 0, _len = overlappingAssignments.length; _i < _len; _i++) {
                assignment = overlappingAssignments[_i];
                _results.push(assignment);
              }
              return _results;
            })()).reduce(function(acc, x) {
              var days, hours;
              days = x.period.overlappingPeriod(period).remainingWorkingDays();
              hours = Math.round(days * 8 * x.focusFactor);
              return acc + hours;
            }, 0);
          }
          return Math.round(hrsPlannedIn);
        },
        availableHoursForPlanning: function(period) {
          var hrsAvailable, maxHours;
          maxHours = Math.round(this.hoursAvailable(period) * 0.8);
          hrsAvailable = Math.round(maxHours - this.hoursPlannedIn(period));
          if (hrsAvailable < 0) {
            return 0;
          } else {
            return hrsAvailable;
          }
        },
        hoursAbsent: function(period) {
          var absence, absent, overlappingAbsences;
          absent = 0;
          overlappingAbsences = (function() {
            var _i, _len, _ref, _results;
            _ref = this.periodsAway;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              absence = _ref[_i];
              if (absence.overlaps(period)) _results.push(absence);
            }
            return _results;
          }).call(this);
          if ((overlappingAbsences != null) && typeof overlappingAbsences !== 'undefined' && overlappingAbsences.length > 0) {
            absent = ((function() {
              var _i, _len, _results;
              _results = [];
              for (_i = 0, _len = overlappingAbsences.length; _i < _len; _i++) {
                absence = overlappingAbsences[_i];
                _results.push(absence.overlappingPeriod(period));
              }
              return _results;
            })()).reduce(function(acc, x) {
              var result;
              result = x.remainingWorkingDays();
              return acc + result;
            }, 0);
          }
          return Math.round(absent * 8);
        },
        hoursAvailable: function(period) {
          var absence, absent, amtDays, available, overlappingAbsences;
          absent = 0;
          overlappingAbsences = (function() {
            var _i, _len, _ref, _results;
            _ref = this.periodsAway;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              absence = _ref[_i];
              if (absence.overlaps(period)) _results.push(absence);
            }
            return _results;
          }).call(this);
          if ((overlappingAbsences != null) && typeof overlappingAbsences !== 'undefined' && overlappingAbsences.length > 0) {
            absent = ((function() {
              var _i, _len, _results;
              _results = [];
              for (_i = 0, _len = overlappingAbsences.length; _i < _len; _i++) {
                absence = overlappingAbsences[_i];
                _results.push(absence.overlappingPeriod(period));
              }
              return _results;
            })()).reduce(function(acc, x) {
              var result;
              result = Math.round(x.remainingWorkingDays());
              return acc + result;
            }, 0);
          }
          amtDays = period.remainingWorkingDays() - absent;
          if (amtDays < 0) amtDays = 0;
          available = Math.round(amtDays * 8);
          return available;
        },
        isOverPlanned: function(period) {
          var maxHours;
          maxHours = Math.round(this.hoursAvailable(period) * 0.8);
          return maxHours < this.hoursPlannedIn(period);
        },
        getOverplannedPeriods: function(period) {
          var ass, assignedPeriods, overplannedPeriods;
          console.log(this.fullName());
          overplannedPeriods = [];
          assignedPeriods = ((function() {
            var _i, _len, _ref, _results;
            _ref = this.assignments;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              ass = _ref[_i];
              if (ass.period.overlaps(period)) _results.push(ass);
            }
            return _results;
          }).call(this)).reduce(function(acc, x) {
            var newFocusFactor, overlap;
            console.log('nieuwe assignmemnt: ' + x.period);
            if (x.focusFactor > 0.8) {
              console.log('focusFactor > 0.8');
              overplannedPeriods.push(x);
            } else if (x.period.overlaps(acc.period)) {
              newFocusFactor = acc.focusFactor + x.focusFactor;
              console.log('period overlaps; newFocusFactor: ' + newFocusFactor);
              if (newFocusFactor > 0.8) {
                console.log('newFocusFactor > 0.8 ');
                overplannedPeriods.push(x);
              } else {
                overlap = {
                  period: acc.period.overlappingPeriod(x.period),
                  focusFactor: newFocusFactor
                };
                console.log('new acc: ' + overlap.period);
                acc = overlap;
              }
            } else {
              console.log('period NOT overlaps');
            }
            console.log('accumulator period value: ' + acc.period);
            return acc;
          }, {
            period: period,
            focusFactor: 0
          });
          console.log(overplannedPeriods);
          return overplannedPeriods;
        },
        hasOverplannedPeriods: function(period) {
          return this.getOverplannedPeriods(period).length > 0;
        }
      });
    }
  };

  RCrud = {
    extended: function() {
      return this.include({
        save: function(url, jsonData, callback) {
          return $.ajax(url, {
            dataType: "json",
            data: jsonData,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + jsonData + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        "delete": function(url, callback) {
          return $.ajax(url, {
            type: "DELETE",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + url + " called succesfully");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX DELETE error: " + errorThrown);
            }
          });
        },
        get: function(url, callback) {
          return $.ajax(url, {
            dataType: "json",
            type: "GET",
            success: function(data, status, XHR) {
              console.log("AJAX data loaded");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX error: " + status);
            }
          });
        }
      });
    }
  };

  RSimpleCrud = {
    setSaveUrl: function(url) {
      return _this.saveUrl = url;
    },
    setDeleteUrl: function(url) {
      return _this.deleteUrl = url;
    },
    setLoadUrl: function(url) {
      return _this.loadUrl = url;
    },
    extended: function() {
      return this.include({
        save: function(jsonData, callback) {
          return $.ajax(saveUrl, {
            dataType: "json",
            data: jsonData,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + jsonData + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        "delete": function(id, callback) {
          var url;
          url = deleteUrl + "/" + id;
          return $.ajax(url, {
            type: "DELETE",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + url + " called succesfully");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX DELETE error: " + errorThrown);
            }
          });
        },
        get: function(callback) {
          return $.ajax(loadUrl, {
            dataType: "json",
            type: "GET",
            success: function(data, status, XHR) {
              console.log("AJAX data loaded");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX error: " + status);
            }
          });
        }
      });
    }
  };

  root.RMoveItem = RMoveItem;

  root.RGroupBy = RGroupBy;

  root.RTeamMember = RTeamMember;

  root.RCrud = RCrud;

  root.RSimpleCrud = RSimpleCrud;

}).call(this);
