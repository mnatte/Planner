# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminEnvironmentViewmodel extends SimpleCrudViewmodel
	constructor: (allEnvironments) ->
		Environment.extend(RSimpleCrud)
		#Environment.extend(REnvironmentSerialize)
		Environment.setSaveUrl "/planner/Environment/Save"
		Environment.setDeleteUrl "/planner/Environment/Delete"
		#@itemToDelete = ko.observable()
		#Resource.setLoadUrl "/planner/Resource/Save"
		super #shortcut for super(allProjects)
		
	createNewItem: (jsonData) =>
		new Environment(jsonData.Id, jsonData.Name, jsonData.Description, jsonData.Location, jsonData.ShortName)

	createNewEmptyItem: =>
		new Environment(0, "", "", "", "")

# export to root object
root.AdminEnvironmentViewmodel = AdminEnvironmentViewmodel