# require release.js
# require knockout 2.0.0.js
# require simpleCrudViewmodel.js

# access (for browser)
root = global ? window

class AdminActivityViewmodel extends SimpleCrudViewmodel
	constructor: (allItems) ->
		Activity.extend(RSimpleCrud)
		Activity.setSaveUrl "/planner/Deliverable/SaveActivity"
		Activity.setDeleteUrl "/planner/Deliverable/DeleteActivity"
		#Resource.setLoadUrl "/planner/Resource/Save"
		super #shortcut for super(allItems)

	createNewItem: (jsonData) =>
		new Activity(jsonData.Id, jsonData.Title, jsonData.Description)

	createNewEmptyItem: =>
		new Activity(0, "", "")

# export to root object
root.AdminActivityViewmodel = AdminActivityViewmodel