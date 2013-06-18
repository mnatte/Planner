# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class EnvironmentsPlanningViewmodel
	constructor: (environments, versions) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		#@selectedPhase = ko.observable()
		@selectedAssignment = ko.observable()
		@selectedEnvironment = ko.observable()
		@selectedVersion = ko.observable()
		@selectedTimelineItem = ko.observable()
		#@selectedMilestone = ko.observable()

		@assignments = ko.observableArray()
		#@selectedPhase.subscribe((newValue) => 
			#loadAssignments newValue.id
			#)

		@environments = ko.observableArray environments
		@versions = ko.observableArray versions
		
		@selectedTimelineItem.subscribe((newValue) =>
			console.log "selected timeline item"
			#@selectedAssignment
			console.log newValue.dataObject
			#console.log @selectedAssignment()
			@selectedAssignment newValue.dataObject

			# make sure our selected values correspond to items in the option collections (@environments and @versions)
			version = i for i in @versions() when i.id is newValue.dataObject.version.id
			environment = i for i in @environments() when i.id is newValue.dataObject.environmentId
			@selectedVersion version
			@selectedEnvironment environment

			#@selectedEnvironment newValue.dataObject.environment 
			#if newValue
				#@selectedMilestone newValue.dataObject
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
		#Deliverable.extend RDeliverableStatus

		updateScreenFunctions = []
		# @selectedTimelineItem is the observable to trigger selected assignment functionality
		#updateScreenFunctions.push(=> @selectedTimelineItem null)
		#updateScreenFunctions.push(=> @selectedMilestone null)
		#updateScreenFunctions.push(=> @selectedDeliverable null)
		@updateScreenUseCase = new UUpdateScreen null, updateScreenFunctions

	newAssignment: =>
		#@selectedAssignment
		console.log "new assignment"
		newAss = { id:0, phase: new Period(new Date(), new Date(), 'New Assignment', 0) }
		@selectedAssignment(newAss)
		console.log @selectedAssignment()

	setAssignments: (jsonData) =>
		console.log "setAssignments"
		@assignments.removeAll()
		@assignments AssignedResource.createCollection(jsonData)

	loadAssignments: (releaseId) ->
		#console.log "loadAssignments"
        ajax = new Ajax()
        ajax.getAssignedResourcesForRelease(releaseId, @setAssignments)
		
	closeDetails: =>
		#console.log "closeDetails"
        @canShowDetails(false)

	createVisualCuesForGates: (data) =>
		console.log "createVisualCuesForGates"
		uc = new UCreateVisualCuesForGates 30, (data) => console.log 'callback succesful: ' + data
		uc.execute()

	selectPhase: (data) =>
		console.log "selectPhase"
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

	saveSelectedAssignment: =>
		console.log "saveSelectedAssignment"
		#@environment, @version, @period, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
		
		useCase = new UPlanEnvironment(@selectedEnvironment(), @selectedVersion(), @selectedAssignment().phase, @environments(), @selectedAssignment(), @updateScreenUseCase, 'undefined', (json) -> Release.create json)
		#uc = new UUpdateDeliverableStatus(@selectedDeliverable(), @allReleases, null, @updateScreenUseCase)
		useCase.execute()
		console.log @selectedAssignment()
		console.log @selectedEnvironment()
		console.log @selectedVersion()

	deleteSelectedAssignment: =>
		console.log "deleteSelectedAssignment"
		useCase = new UUnAssignEnvironment(@selectedEnvironment(), @selectedVersion(), @selectedAssignment().phase, @environments(), @selectedAssignment(), @updateScreenUseCase)
		#uc = new UUpdateDeliverableStatus(@selectedDeliverable(), @allReleases, null, @updateScreenUseCase)
		useCase.execute()

# export to root object
root.EnvironmentsPlanningViewmodel = EnvironmentsPlanningViewmodel