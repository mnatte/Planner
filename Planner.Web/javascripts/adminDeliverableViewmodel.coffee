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
		for del in @allItems()
			@setDeliverableActivities del

	createNewItem: (jsonData) =>
		#new Deliverable(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.Format, jsonData.Location)
		del = Deliverable.create jsonData
		@setDeliverableActivities del
		del

	createNewEmptyItem: =>
		new Deliverable(0, "", "", "", "")

	setDeliverableActivities: (del) ->
		# assign activities and transform activities array to observableArray so changes will be registered
		delacts = del.activities.slice() # use slice to create independent copy instead of copying the reference (by delacts = del.activities)
		del.activities = ko.observableArray([])
		for act in delacts
			for a in @allActivities() when a.id is act.id
				#console.log "assign project #{p.title}"
				del.activities.push a		

# export to root object
root.AdminDeliverableViewmodel = AdminDeliverableViewmodel