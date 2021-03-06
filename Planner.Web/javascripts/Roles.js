(function() {
  var RCrud, RDeliverableStatus, RGroupBy, RLookUp, RMoveItem, RPlanEnvironment, RScheduleItem, RSchedulePeriod, RSimpleCrud, RTeamMember, root,
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

  RLookUp = {
    extended: function() {
      return this.include({
        lookUp: function(collection) {
          var i, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = collection.length; _i < _len; _i++) {
            i = collection[_i];
            if (+i.id === +this.id) _results.push(i);
          }
          return _results;
        },
        refreshInCollection: function(collection) {
          var index, oldItem, r, _i, _len;
          for (_i = 0, _len = collection.length; _i < _len; _i++) {
            r = collection[_i];
            if (+r.id === +this.id) oldItem = r;
          }
          index = collection.indexOf(oldItem);
          return collection.splice(index, 1, this);
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
        getPlanning: function(period) {
          var abs, absences, ass, assignments;
          absences = (function() {
            var _i, _len, _ref, _results;
            _ref = this.periodsAway;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              abs = _ref[_i];
              if (abs.overlaps(period)) _results.push(abs);
            }
            return _results;
          }).call(this);
          assignments = (function() {
            var _i, _len, _ref, _results;
            _ref = this.assignments;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              ass = _ref[_i];
              if (ass.period.overlaps(period)) _results.push(ass);
            }
            return _results;
          }).call(this);
          return {
            absences: absences,
            assignments: assignments
          };
        },
        getPlannedHoursPerAssignmentIncludingAbsences: function(period) {
          var assignment, overview, planning;
          planning = this.getPlanning(period);
          overview = [];
          if ((planning.assignments != null) && typeof planning.assignments !== 'undefined' && planning.assignments.length > 0) {
            overview = ((function() {
              var _i, _len, _ref, _results;
              _ref = planning.assignments;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                assignment = _ref[_i];
                _results.push(assignment);
              }
              return _results;
            })()).reduce(function(acc, x) {
              var dys, hrs;
              console.log(assignment);
              dys = x.period.overlappingPeriod(period).workingDays();
              hrs = Math.round(dys * 8 * x.focusFactor);
              acc.push({
                days: dys,
                hours: hrs,
                assignment: x.activity.title + ' ' + x.deliverable.title + ' ' + x.focusFactor * 100 + '%'
              });
              return acc;
            }, []);
          }
          overview.push({
            days: this.daysAbsent(period),
            hours: this.hoursAbsent(period),
            assignment: 'Absent'
          });
          console.log(overview);
          return overview;
        },
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
        daysAbsent: function(period) {
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
          return Math.round(absent);
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
              console.log("RTeamMember hoursAvailable");
              console.log(x);
              console.log(x.remainingWorkingDays());
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
            console.log('nieuwe assignment: ' + x.period);
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
              acc = {
                period: x.period,
                focusFactor: x.focusFactor
              };
            }
            console.log('accumulator period value: ' + acc.period);
            return acc;
          }, {
            period: period,
            focusFactor: 0
          });
          return overplannedPeriods;
        },
        hasOverplannedPeriods: function(period) {
          var ret;
          ret = this.getOverplannedPeriods(period).length > 0;
          return ret;
        },
        plan: function(rel, proj, ms, del, act, per, ff, callback) {
          return $.ajax("/planner/Resource/Plan", {
            dataType: "json",
            data: ko.toJSON({
              phaseId: rel.id,
              projectId: proj.id,
              milestoneId: ms.id,
              deliverableId: del.id,
              activityId: act.id,
              startDate: per.startDate.dateString,
              endDate: per.endDate.dateString,
              focusFactor: ff,
              resourceId: this.id
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("planned resource saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        unassign: function(rel, proj, ms, del, act, per, callback) {
          return $.ajax("/planner/Resource/UnAssign", {
            dataType: "json",
            data: ko.toJSON({
              phaseId: rel.id,
              projectId: proj.id,
              milestoneId: ms.id,
              deliverableId: del.id,
              activityId: act.id,
              startDate: per.startDate.dateString,
              endDate: per.endDate.dateString,
              resourceId: this.id
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("resource unassigned");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        planForRelease: function(rel, proj, ms, del, act, per, ff, callback) {
          return $.ajax("/planner/Resource/Release/Plan", {
            dataType: "json",
            data: ko.toJSON({
              phaseId: rel.id,
              projectId: proj.id,
              milestoneId: ms.id,
              deliverableId: del.id,
              activityId: act.id,
              startDate: per.startDate.dateString,
              endDate: per.endDate.dateString,
              focusFactor: ff,
              resourceId: this.id
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("planned resource saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        unassignFromRelease: function(rel, proj, ms, del, act, per, callback) {
          return $.ajax("/planner/Resource/Release/UnAssign", {
            dataType: "json",
            data: ko.toJSON({
              phaseId: rel.id,
              projectId: proj.id,
              milestoneId: ms.id,
              deliverableId: del.id,
              activityId: act.id,
              startDate: per.startDate.dateString,
              endDate: per.endDate.dateString,
              resourceId: this.id
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("resource unassigned");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
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

  RScheduleItem = {
    setScheduleUrl: function(url) {
      return _this.scheduleUrl = url;
    },
    extended: function() {
      return this.include({
        schedule: function(itemId, relId, dateString, timeString, callback) {
          return $.ajax(scheduleUrl, {
            dataType: "json",
            data: ko.toJSON({
              time: timeString,
              date: dateString,
              releaseId: relId,
              eventId: itemId
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + data + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        }
      });
    }
  };

  RSchedulePeriod = {
    setScheduleUrl: function(url) {
      return _this.scheduleUrl = url;
    },
    extended: function() {
      return this.include({
        schedule: function(periodId, relId, startDateString, endDateString, callback) {
          return $.ajax(scheduleUrl, {
            dataType: "json",
            data: ko.toJSON({
              startDate: startDateString,
              endDate: endDateString,
              releaseId: relId,
              eventId: periodId
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + data + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        }
      });
    }
  };

  RPlanEnvironment = {
    setPlanUrl: function(url) {
      return _this.planUrl = url;
    },
    setUnAssignUrl: function(url) {
      return _this.unAssignUrl = url;
    },
    extended: function() {
      return this.include({
        plan: function(version, period, callback) {
          console.log(period.title);
          return $.ajax(planUrl, {
            dataType: "json",
            data: ko.toJSON({
              purpose: period.title,
              startDate: period.startDate.dateString,
              endDate: period.endDate.dateString,
              phaseId: period.id,
              version: version,
              environment: this
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + data + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        },
        unplan: function(version, period, callback) {
          console.log(period);
          return $.ajax(unAssignUrl, {
            dataType: "json",
            data: ko.toJSON({
              phaseId: period.id,
              version: version,
              environment: this
            }),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(data, status, XHR) {
              console.log("" + data + " saved");
              return callback(data);
            },
            error: function(XHR, status, errorThrown) {
              return console.log("AJAX SAVE error: " + errorThrown);
            }
          });
        }
      });
    }
  };

  RDeliverableStatus = {
    extended: function() {
      return this.include({
        isUnderPlanned: function() {
          var act, activities, proj, underplanned, _i, _j, _len, _len2, _ref;
          underplanned = false;
          _ref = this.scope;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            proj = _ref[_i];
            activities = proj.workload.reduce(function(acc, x) {
              acc.push({
                activityTitle: x.activity.title,
                hrs: x.hoursRemaining,
                planned: x.assignedResources.reduce((function(acc, x) {
                  return acc + x.resourceAvailableHours();
                }), 0)
              });
              return acc;
            }, []);
            for (_j = 0, _len2 = activities.length; _j < _len2; _j++) {
              act = activities[_j];
              underplanned = act.hrs > act.planned;
            }
          }
          return underplanned;
        },
        plannedHours: function() {
          var activities, hours, proj, _i, _len, _ref;
          hours = 0;
          _ref = this.scope;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            proj = _ref[_i];
            activities = proj.workload.reduce(function(acc, x) {
              acc.push({
                activityTitle: x.activity.title,
                hrs: x.hoursRemaining,
                planned: x.assignedResources.reduce((function(acc, x) {
                  return acc + x.resourceAvailableHours();
                }), 0)
              });
              return acc;
            }, []);
            hours += activities.reduce(function(acc, x) {
              return acc + x.planned;
            }, 0);
          }
          return hours;
        }
      });
    }
  };

  root.RMoveItem = RMoveItem;

  root.RGroupBy = RGroupBy;

  root.RTeamMember = RTeamMember;

  root.RCrud = RCrud;

  root.RSimpleCrud = RSimpleCrud;

  root.RScheduleItem = RScheduleItem;

  root.RSchedulePeriod = RSchedulePeriod;

  root.RDeliverableStatus = RDeliverableStatus;

  root.RPlanEnvironment = RPlanEnvironment;

  root.RLookUp = RLookUp;

}).call(this);
