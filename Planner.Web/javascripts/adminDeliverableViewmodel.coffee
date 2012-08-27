# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminDeliverableViewmodel extends SimpleCrudViewmodel
	constructor: (allResources) ->
		Deliverable.extend(RSimpleCrud)
		Deliverable.setSaveUrl "/planner/Deliverable/Save"
		Deliverable.setDeleteUrl "/planner/Deliverable/Delete"
		#Resource.setLoadUrl "/planner/Resource/Save"
		super #shortcut for super(allResources)

	createNewItem: (jsonData) =>
		new Deliverable(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.Format, jsonData.Location)

	createNewEmptyItem: =>
		new Deliverable(0, "", "", "", "")

# export to root object
root.AdminDeliverableViewmodel = AdminDeliverableViewmodel