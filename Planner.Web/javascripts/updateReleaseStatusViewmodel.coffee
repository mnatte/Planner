# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class UpdateReleaseStatusViewmodel
	constructor: (@allReleases) ->
		# Phase.extend(RCrud)
		# Milestone.extend(RCrud)
		Deliverable.extend(RCrud)
		Deliverable.extend(RDeliverableSerialize)
		@selectedRelease = ko.observable()
		@selectedMilestone = ko.observable()
		@selectedDeliverable = ko.observable()
		@selectedProject = ko.observable()

		for rel in @allReleases
			do (rel) ->
				# console.log "ctor sort rel: #{rel}"
				rel.milestones.sort((a,b)-> if a.date.date > b.date.date then 1 else if a.date.date < b.date.date then -1 else 0)
		@allReleases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)


	# functions for observable necessary to pass view model data to it from html
	selectRelease: (data) =>
		console.log "selectRelease - function"
		@selectedRelease data
		console.log @selectedRelease.projects
		# reset selected Milestone and Deliverable
		@selectMilestone null
		@selectDeliverable null
		#console.log "selectRelease after selection: " + @selectedRelease().title + ", parentId: " +  @selectedRelease().parentId

	selectMilestone: (data) =>
		console.log "selectMilestone - function"
		@selectedMilestone data
		# reset selected Deliverable
		@selectDeliverable null
		console.log @selectedMilestone()

	selectDeliverable: (data) =>
		console.log "selectDeliverable - function"
		# console.log @
		# console.log data
		@selectedDeliverable data
		console.log @selectedDeliverable()

	refreshRelease: (index, jsonData) =>
		#reload deliverable activity statuses per project

	saveSelectedDeliverable: =>
		console.log "saveSelectedDeliverable: selectedRelease: #{@selectedRelease()}"
		console.log "saveSelectedDeliverable: selectedMilestone: #{@selectedMilestone()}"
		console.log @selectedDeliverable().toStatusJSON()
		#console.log ko.toJSON(@selectedDeliverable().milestoneId)
		#i = @allReleases().indexOf(@selectedRelease())
		@selectedDeliverable().save("/planner/Release/SaveDeliverableStatus", ko.toJSON(@selectedDeliverable().toStatusJSON()), (data) => @refreshRelease(0, data))
	
# export to root object
root.UpdateReleaseStatusViewmodel = UpdateReleaseStatusViewmodel