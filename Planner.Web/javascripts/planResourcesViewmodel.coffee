# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PlanResourcesViewmodel
	constructor: (allReleases, allResources) ->
		AssignedResource.extend(RCrud)
		@selectedProject = ko.observable()
		@selectedRelease = ko.observable()
		@selectedPhase = ko.observable()
		@selectedResource = ko.observable()
		@newAssignment = new AssignedResource(0, "", "", "", "", "", "", "", "", 0.8)
		@allReleases = ko.observableArray(allReleases)
		@allResources = ko.observableArray(allResources)
		@assignments = ko.observableArray()
		@canShowForm = ko.observable(false)

		#for rel in @allReleases()
		#	do (rel) ->
		#		rel.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		#@allReleases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		
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
		@assignments (AssignedResource.createCollection jsonData)

	loadAssignments: ->
        ajax = new Ajax()
        ajax.getAssignedResources(@selectedRelease().id, @selectedProject().id, @setAssignments)

	addResource: ->
		@canShowForm(true)

	closeForm: =>
        @canShowForm(false)

	saveAssignment: =>
		#console.log(@selectedRelease())
		@newAssignment.phase = @selectedRelease()
		@newAssignment.resource = @selectedResource()
		@newAssignment.project = @selectedProject()
		#console.log(@newAssignment.phase)
		#console.log(@newAssignment.resource)
		#console.log(@newAssignment.project)
		#console.log(ko.toJSON(@newAssignment))
		@newAssignment.save("/planner/ResourceAssignment/Save", ko.toJSON(@newAssignment), (data) => console.log(data))

# export to root object
root.PlanResourcesViewmodel = PlanResourcesViewmodel