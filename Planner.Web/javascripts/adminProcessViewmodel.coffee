# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminProcessViewmodel extends SimpleCrudViewmodel
	constructor: (allProcesses) ->
		Process.extend(RSimpleCrud)
		#Process.extend(REnvironmentSerialize)
		Process.setSaveUrl "/planner/Process/Save"
		Process.setDeleteUrl "/planner/Process/Delete"
		#Resource.setLoadUrl "/planner/Resource/Save"
		super #shortcut for super(allItems)
		
	createNewItem: (jsonData) =>
		#new Process(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.ShortName)
		Process.create(jsonData)

	createNewEmptyItem: =>
		#new Environment(0, "", "", "", "")
		Process.createEmpty()

# export to root object
root.AdminProcessViewmodel = AdminProcessViewmodel