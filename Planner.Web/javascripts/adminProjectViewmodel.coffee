# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminProjectViewmodel extends SimpleCrudViewmodel
	constructor: (allProjects) ->
		Project.extend(RSimpleCrud)
		Project.extend(RProjectSerialize)
		Project.setSaveUrl "/planner/Project/Save"
		Project.setDeleteUrl "/planner/Project/Delete"
		#@itemToDelete = ko.observable()
		#Resource.setLoadUrl "/planner/Resource/Save"
		super #shortcut for super(allProjects)

	createNewItem: (jsonData) =>
		new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description)

	createNewEmptyItem: =>
		new Project(0, "", "", "")

# export to root object
root.AdminProjectViewmodel = AdminProjectViewmodel