# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PlanResourcesViewmodel extends Mixin
	constructor: (allReleases, allResources) ->
		ReleaseAssignments.extend(RCrud)
		# console.log allReleases
		PlanResourcesViewmodel.extend(RGroupBy)
		@selectedProject = ko.observable()
		@selectedRelease = ko.observable()
		@selectedPhase = ko.observable()
		@selectedResource = ko.observable()
		@assignedStartDate = ko.observable()
		@assignedEndDate = ko.observable()
		@newAssignment = new AssignedResource(0, "", "", "", "", "", "", "", "", 0.8, new Date(), new Date())
		@allReleases = ko.observableArray(allReleases)
		@allResources = ko.observableArray(allResources)
		@assignments = ko.observableArray()
		@canShowForm = ko.observable(false)

		# setup nice 'remove' method for Array
		Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

	selectRelease: (data) =>
		@selectedRelease data

	selectProject: (data) =>
		@selectedProject data

	selectPhase: (data) =>
		@selectedPhase data

	setAssignments: (jsonData) =>
		@assignments.removeAll()
		@assignments AssignedResource.createCollection(jsonData, @selectedProject(), @selectedRelease())

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
		#copy = @newAssignment
		#copy.phase = @selectedRelease()
		#copy.resource = @selectedResource()
		#copy.project = @selectedProject()
		#console.log ko.toJSON(copy)
		#assignedPeriod.startDate.dateString databinding in htmlform automatically transforms to underlying DatePlus type 
		console.log @newAssignment.assignedPeriod.startDate
		console.log @newAssignment.assignedPeriod.endDate.dateString
		console.log @newAssignment.assignedPeriod.endDate.date
		ass = new AssignedResource(0, @selectedRelease(), @selectedResource(), @selectedProject(), @newAssignment.focusFactor, DateFormatter.createFromString(@newAssignment.assignedPeriod.startDate.dateString), DateFormatter.createFromString(@newAssignment.assignedPeriod.endDate.dateString))
		console.log ass
		@assignments.push ass
		#@allResources.remove @selectedResource()
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
		console.log(ko.toJSON(dto))
		#TODO: Reload through callbacks
		dto.save("/planner/ResourceAssignment/SaveAssignments", ko.toJSON(dto), (data) => console.log(data))

	openDetailsWindow: (model) =>
		window.open "Release.htm?RelId=#{@selectedRelease().id}"

# export to root object
root.PlanResourcesViewmodel = PlanResourcesViewmodel