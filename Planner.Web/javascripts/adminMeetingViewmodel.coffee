# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminMeetingViewmodel extends SimpleCrudViewmodel
	constructor: (allMeetings) ->
		Meeting.extend(RSimpleCrud)
		Meeting.extend(RScheduleItem)
		#Meeting.extend(RProjectSerialize)
		Meeting.setSaveUrl "/planner/Meeting/Save"
		Meeting.setDeleteUrl "/planner/Meeting/Delete"
		Meeting.setScheduleUrl "/planner/Meeting/Schedule"
		@date = ko.observable()
		@time = ko.observable()
		@releaseId = ko.observable()
		super #shortcut for super(allMeetings)

# SimpleCrudViewmodel
	createNewItem: (jsonData) =>
		new Meeting(jsonData.Id, jsonData.Title, jsonData.Objective, jsonData.Description, jsonData.Moment)

	createNewEmptyItem: =>
		new Meeting(0, "", "", "", "")

# schedule meeting: itemId, relId, dateString, timeString, callback
	scheduleMeeting: =>
		@selectedItem().schedule(@selectedItem().id, @releaseId(), @date(), @time(), (data) => @refreshItem(i, data))

# export to root object
root.AdminMeetingViewmodel = AdminMeetingViewmodel