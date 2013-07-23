# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class EnvironmentsPlanningViewmodel
	constructor: (environments, versions) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedAssignment = ko.observable()
		@selectedEnvironment = ko.observable()
		@selectedVersion = ko.observable()
		@selectedTimelineItem = ko.observable()

		@assignments = ko.observableArray()
		@environments = ko.observableArray environments
		@versions = ko.observableArray versions
		
		@selectedTimelineItem.subscribe((newValue) =>
			console.log "selected timeline item"
			console.log newValue.dataObject
			@selectedAssignment newValue.dataObject

			# make sure our selected values correspond to items in the option collections (@environments and @versions)
			version = i for i in @versions() when i.id is newValue.dataObject.version.id
			environment = i for i in @environments() when i.id is newValue.dataObject.environmentId
			@selectedVersion version
			@selectedEnvironment environment
			)
		@selectedAssignment.subscribe((newValue) => 
			console.log "selected assignment"
			console.log newValue
			#@selectedVersion newValue.version
			)
		@selectedVersion.subscribe((newValue) => 
			console.log "selected version changed"
			console.log newValue
			)
		@selectedEnvironment.subscribe((newValue) => 
			console.log "selected environment"
			console.log newValue
			)

		updateScreenFunctions = []
		updateScreenUseCases = []
		updateScreenUseCases.push(new UDisplayEnvironmentsGraph(@environments(), @selectedTimelineItem))
		updateScreenFunctions.push(=> @selectedAssignment null)
		updateScreenFunctions.push(=> @selectedVersion null)
		updateScreenFunctions.push(=> @selectedEnvironment null)
		@updateScreenUseCase = new UUpdateScreen updateScreenUseCases, updateScreenFunctions

	newAssignment: =>
		console.log "new assignment"
		newAss = { id:0, phase: new Period(new Date(), new Date(), 'New Assignment', 0) }
		@selectedAssignment(newAss)
		console.log @selectedAssignment()

	setAssignments: (jsonData) =>
		console.log "setAssignments"
		@assignments.removeAll()
		@assignments AssignedResource.createCollection(jsonData)

	loadAssignments: (releaseId) ->
        ajax = new Ajax()
        ajax.getAssignedResourcesForRelease(releaseId, @setAssignments)
		
	createVisualCuesForDates: (data) =>
		#console.log "createVisualCuesForGates"
		#uc = new UCreateVisualCuesForGates 30, (data) => console.log 'callback succesful: ' + data
		#uc.execute()

	dehydrateEnvironment: (json) =>
		env = Environment.create json

	saveSelectedAssignment: =>
		console.log "saveSelectedAssignment"
		#ctor: @environment, @version, @period, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
		useCase = new UPlanEnvironment(@selectedEnvironment(), @selectedVersion(), @selectedAssignment().phase, @environments, null, @updateScreenUseCase, null, @dehydrateEnvironment)
		useCase.execute()
		console.log @selectedAssignment()
		console.log @selectedEnvironment()
		console.log @selectedVersion()

	deleteSelectedAssignment: =>
		console.log "deleteSelectedAssignment"
		#ctor: (@environment, @version, @period, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate)
		useCase = new UUnAssignEnvironment(@selectedEnvironment(), @selectedVersion(), @selectedAssignment().phase, @environments, null, @updateScreenUseCase, null, @dehydrateEnvironment)
		useCase.execute()

# export to root object
root.EnvironmentsPlanningViewmodel = EnvironmentsPlanningViewmodel