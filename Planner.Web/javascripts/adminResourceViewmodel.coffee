# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminResourceViewmodel extends SimpleCrudViewmodel
	constructor: (allResources) ->
		Resource.extend(RSimpleCrud)
		Resource.setSaveUrl "/planner/Resource/Save"
		Resource.setDeleteUrl "/planner/Resource/Delete"
		#Resource.setLoadUrl "/planner/Resource/Save"
		super #shortcut for super(allResources)

	createNewItem: (jsonData) =>
		new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber)

	createNewEmptyItem: =>
		new Resource(0, "", "", "", "", "", "", "")

# export to root object
root.AdminResourceViewmodel = AdminResourceViewmodel