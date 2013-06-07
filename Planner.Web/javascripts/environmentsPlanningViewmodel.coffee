# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class EnvironmentsPlanningViewmodel
	constructor: (environments, versions) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedPhase = ko.observable()
		@selectedAssignment = ko.observable()
		@selectedEnvironment = ko.observable()
		@selectedVersion = ko.observable()
		@selectedTimelineItem = ko.observable()
		@selectedMilestone = ko.observable()

		@assignments = ko.observableArray()
		@selectedPhase.subscribe((newValue) => 
			loadAssignments newValue.id
			)

		@environments = ko.observableArray environments
		@versions = ko.observableArray versions
		
		@selectedTimelineItem.subscribe((newValue) =>
			console.log "selected timeline item"
			#@selectedAssignment
			console.log newValue.dataObject
			console.log @selectedAssignment()
			@selectedAssignment newValue.dataObject
			#@selectedEnvironment newValue.dataObject.environment 
			#if newValue
				#@selectedMilestone newValue.dataObject
			)
		@selectedAssignment.subscribe((newValue) => 
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
		@assignments.removeAll()
		@assignments AssignedResource.createCollection(jsonData)

	loadAssignments: (releaseId) ->
        ajax = new Ajax()
        ajax.getAssignedResourcesForRelease(releaseId, @setAssignments)
		
	closeDetails: =>
        @canShowDetails(false)

	createVisualCuesForGates: (data) =>
		uc = new UCreateVisualCuesForGates 30, (data) => console.log 'callback succesful: ' + data
		uc.execute()

	selectPhase: (data) =>
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

	saveSelectedAssignment: =>
		#useCase = new UModifyAssignment(x, @allReleases, @inspectRelease, @updateScreenUseCase, @newAssignment, "release", (json) -> Release.create json)
		#uc = new UUpdateDeliverableStatus(@selectedDeliverable(), @allReleases, null, @updateScreenUseCase)
		#uc.execute()

	deleteSelectedAssignment: =>
		#console.log @selectedAbsence()
		#abs = (a for a in @showAbsences when a.dataObject.id is @selectedAbsence().id)[0]
		# use index for removing from @allReleases
		#i = @showAbsences.indexOf(abs)
		#console.log 'index: ' + i
		#@selectedAbsence().delete("/planner/Resource/DeleteAbsence/" + @selectedAbsence().id, (callbackdata) =>
			# check for server error is done in Roles.coffee RCrud delete method
			#console.log callbackdata
			#@showAbsences.splice i, 1
			#next = @showAbsences[i]
			#console.log next
			#@selectedTimelineItem next
			#$.unblockUI()
		#)

# export to root object
root.EnvironmentsPlanningViewmodel = EnvironmentsPlanningViewmodel