# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PlanResourcesViewmodel extends Mixin
	constructor: (allReleases, allResources, allActivities) ->
		Assignment.extend(RAssignmentSerialize)
		ReleaseAssignments.extend(RCrud)
		# console.log allReleases
		PlanResourcesViewmodel.extend(RGroupBy)
		Resource.extend RTeamMember
		@selectedProject = ko.observable()
		@selectedRelease = ko.observable()
		@selectedPhase = ko.observable()
		@selectedMilestone = ko.observable()
		@selectedDeliverable = ko.observable()
		@selectedResource = ko.observable()
		@selectedActivity = ko.observable()
		@assignedStartDate = ko.observable()
		@assignedEndDate = ko.observable()

		@selectedMilestone.subscribe((newValue) => 
			#@setEndDate newValue.date.date 
			if(typeof(newValue) isnt "undefined" and newValue isnt null)
				@newAssignment new Assignment(0, "", "", "", 0.8, new Date(), newValue.date.date, "", new Milestone(), new Deliverable())
				console.log @newAssignment()
			)
		@selectedRelease.subscribe((newValue) => 
			console.log 'selectedRelease changed'
			console.log newValue
			)
		@setEndDate = ko.observable(new Date())
		@newAssignment = ko.observable(new Assignment(0, "", "", "", 0.8, new Date(), new Date(), "", new Milestone(), new Deliverable()))
		@allReleases = ko.observableArray(allReleases)
		@allResources = ko.observableArray(allResources)
		@assignments = ko.observableArray()
		@canShowForm = ko.observable(false)
		@allActivities = allActivities

	selectRelease: (data) =>
		@selectedRelease data

	selectProject: (data) =>
		@selectedProject data

	selectPhase: (data) =>
		@selectedPhase data

	setAssignments: (jsonData) =>
		@assignments.removeAll()
		@assignments Assignment.createCollection(jsonData, null, @selectedProject(), @selectedRelease())

	loadAssignments: ->
        ajax = new Ajax()
        ajax.getAssignedResources(@selectedRelease().id, @selectedProject().id, @setAssignments)

	addResource: ->
		@canShowForm(true)

	# this way we need to refer from HTML as availableResources() - with '()'
	# when using @allResources, in HTML this must be referred as allResources - without '()'
	availableResources: =>
		assigned = []
		for a in @assignments()
			assigned.push a.resource.id
		available = (res for res in @allResources() when res.id not in assigned)
		available

	addAssignment: =>
		console.log "addAssignment"
		ass = new Assignment(0, @selectedRelease(), @selectedResource(), @selectedProject(), @newAssignment().focusFactor, DateFormatter.createFromString(@newAssignment().period.startDate.dateString), DateFormatter.createFromString(@newAssignment().period.endDate.dateString), @selectedActivity(), @selectedMilestone(), @selectedDeliverable())
		console.log ass
		@assignments.push ass
		
		@canShowForm(false)

	removeAssignment: (ass) =>
		@assignments.remove ass
		

	closeForm: =>
        @canShowForm(false)

	saveAssignments: =>
		#console.log(@selectedRelease())
		
		#console.log(@newAssignment.phase)
		#console.log(@newAssignment.resource)
		#console.log(@newAssignment.project)
		dto = new ReleaseAssignments(@selectedRelease().id, @selectedProject().id, @assignments())
		console.log(@assignments())
		console.log('saveAssignments')
		console.log(ko.toJSON(dto))
		#TODO: Reload through callbacks
		dto.save("/planner/ResourceAssignment/SaveAssignments", ko.toJSON(dto), (data) => console.log(data))

	openDetailsWindow: (model) =>
		window.open "Release.htm?RelId=#{@selectedRelease().id}"

# export to root object
root.PlanResourcesViewmodel = PlanResourcesViewmodel