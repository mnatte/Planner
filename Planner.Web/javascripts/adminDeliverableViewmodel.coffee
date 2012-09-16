# require release.js
# require knockout 2.0.0.js
# require simpleCrudViewmodel.js

# access (for browser)
root = global ? window

class AdminDeliverableViewmodel extends SimpleCrudViewmodel
	constructor: (allItems, allActivities) ->
		Deliverable.extend(RSimpleCrud)
		Deliverable.setSaveUrl "/planner/Deliverable/Save"
		Deliverable.setDeleteUrl "/planner/Deliverable/Delete"
		#Resource.setLoadUrl "/planner/Resource/Save"
		@allActivities = ko.observableArray(allActivities)
		super #shortcut for super(allItems)

	createNewItem: (jsonData) =>
		#new Deliverable(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.Format, jsonData.Location)
		Deliverable.create jsonData

	createNewEmptyItem: =>
		new Deliverable(0, "", "", "", "")

# export to root object
root.AdminDeliverableViewmodel = AdminDeliverableViewmodel