# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminMeetingViewmodel extends SimpleCrudViewmodel
	constructor: (allMeetings) ->
		Meeting.extend(RSimpleCrud)
		#Meeting.extend(RProjectSerialize)
		Meeting.setSaveUrl "/planner/Meeting/Save"
		Meeting.setDeleteUrl "/planner/Meeting/Delete"
		super #shortcut for super(allMeetings)

	createNewItem: (jsonData) =>
		new Meeting(jsonData.Id, jsonData.Title, jsonData.Objective, jsonData.Description, jsonData.Moment)

	createNewEmptyItem: =>
		new Meeting(0, "", "", "", "")

# export to root object
root.AdminMeetingViewmodel = AdminMeetingViewmodel