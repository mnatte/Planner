# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseOverviewViewmodel
	constructor: (allReleases, @allResources, @allActivities) ->
		# ctor is executed in context of INSTANCE. Therefore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@inspectRelease = ko.observable()
		# used for update selected assignment
		@selectedTimelineItem = ko.observable()
		@selectedReleaseTimelineItem = ko.observable()
		@selectedMilestone = ko.observable()
		@selectedPhase = ko.observable()
		@selectedProject = ko.observable()
		@newAssignment = ko.observable()
		@canShowDetails = ko.observable(false)
		#@assignments = ko.observableArray()
		@allReleases = ko.observableArray(allReleases)
		# used for new assignment
		@selectedResource = ko.observable()
		@selectedDeliverable = ko.observable()
		@selectedActivity = ko.observable()
		@selectedResource.subscribe((newValue) => 
			console.log newValue
			uc = new UDisplayPlanningForResource(newValue, @newAssignment().period)
			uc.execute()
			)

		@resourcesToAssign = ko.observableArray()
		@resourcesToAssign.subscribe((newValue) => 
			console.log newValue
			include = newValue.reduce (acc, x) =>
							resource = r for r in @allResources when +r.id is +x
							acc.push resource
						 acc
					, []
			@resourcesInTimeline(include)
			)
		@resourcesInTimeline = ko.observableArray()
		@resourcesInTimeline.subscribe((newValue) =>
			uc = new UDisplayPlanningForMultipleResources(@resourcesToAssign(), @newAssignment().period)
			uc.execute()
			)

		@selectedReleaseTimelineItem.subscribe((newValue) => 
			console.log newValue
			@selectedAssignment null
			if newValue
				if newValue.dataObject.deliverables
					@selectedMilestone newValue
				else
					@selectedPhase newValue
			)

		@selectedPhase.subscribe((newValue) => 
			if newValue
				console.log newValue
				newValue.dataObject.release = { id: @inspectRelease().id, title: @inspectRelease().title }
				@newAssignment null
				@selectedMilestone null
			)
		@selectedMilestone.subscribe((newValue) => 
			console.log newValue
			if newValue
				ms = newValue.dataObject
				deliverables = []
				for del in newValue.dataObject.deliverables
					deliverables.push({id: del.id, title: del.title, activities: del.activities})
				ms.deliverables = deliverables
				x = { id: 0, release: { id: @inspectRelease().id, title: @inspectRelease().title }, focusFactor: 0.8, period: new Period(new Date(), newValue.dataObject.date.date, "new assignment"), milestone: ms, resource: @selectedResource, deliverable: @selectedDeliverable, activity: @selectedActivity }
			@newAssignment x
			@selectedPhase null
			)
		@selectedAssignment = ko.observable()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			if newValue
				x = newValue.dataObject
				x.resourceName = newValue.dataObject.resource.fullName()
				x.resourceId = newValue.dataObject.resource.id
				#x.period = newValue.dataObject.assignedPeriod
				console.log x
			@selectedAssignment x
			)
		updateScreenUseCases = []
		updateScreenFunctions = []
		# @selectedMilestone is the observable to trigger new assignment functionality
		updateScreenUseCases.push(new UDisplayReleaseTimeline(@inspectRelease, @selectedReleaseTimelineItem))
		# @selectedTimelineItem is the observable to trigger selected assignment functionality
		updateScreenUseCases.push(new UDisplayReleasePlanningInTimeline(@inspectRelease, @selectedTimelineItem, @allResources))
		#updateScreenUseCases.push(new UDisplayPlannedHoursPerActivityArtefactProject(@inspectRelease))
		updateScreenFunctions.push(=> @selectedTimelineItem null)
		updateScreenFunctions.push(=> @selectedMilestone null)
		updateScreenFunctions.push(=> @selectedPhase null)
		@updateScreenUseCase = new UUpdateScreen updateScreenUseCases, updateScreenFunctions
		Resource.extend RTeamMember
		Assignment.extend RAssignmentSerialize
		Assignment.extend RCrud

	viewReleasePlanning: (selectedRelease) =>
		console.log selectedRelease
		@inspectRelease selectedRelease
		@updateScreenUseCase.execute()

	saveSelectedAssignment: =>
		useCase = new UModifyAssignment(@selectedAssignment(), @allReleases, @inspectRelease, @updateScreenUseCase, @selectedAssignment, "release", (json) -> Release.create json)
		useCase.execute()

	saveNewAssignment: =>
		res = new Resource(@selectedResource().id, @selectedResource().firstName, @selectedResource().middleName, @selectedResource().lastName)
		ms = { id: @newAssignment().milestone.id, title: @newAssignment().milestone.title }
		x = @newAssignment()
		x.resource = res
		x.milestone = ms
		x.project = @selectedProject()
		x.activity = @selectedActivity()
		x.deliverable = @selectedDeliverable()

		useCase = new UModifyAssignment(x, @allReleases, @inspectRelease, @updateScreenUseCase, @newAssignment, "release", (json) -> Release.create json)
		useCase.execute()

	deleteSelectedAssignment: => #(@assignment, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase
		useCase = new UDeleteAssignment(@selectedAssignment(), @allReleases, @inspectRelease, @updateScreenUseCase, @selectedAssignment, "release", (json) -> Release.create json)
		useCase.execute()

	rescheduleSelectedMilestone: =>
		date = DateFormatter.createFromString @selectedMilestone().dataObject.date.dateString
		ms = new Milestone(@selectedMilestone().dataObject.id, date, @selectedMilestone().dataObject.time, null, null, @selectedMilestone().dataObject.release.id)
		uc = new URescheduleMilestone(ms, @allReleases, @inspectRelease, @updateScreenUseCase, @selectedAssignment, (json) -> Release.create json)
		uc.execute()

	rescheduleSelectedPeriod: =>
		startDate = DateFormatter.createFromString @selectedPhase().dataObject.startDate.dateString
		endDate = DateFormatter.createFromString @selectedPhase().dataObject.endDate.dateString
		phase = new Phase(@selectedPhase().dataObject.id, startDate, endDate, null, @selectedPhase().dataObject.release.id)
		uc = new UReschedulePhase(phase, @allReleases, @inspectRelease, @updateScreenUseCase, @selectedAssignment, (json) -> Release.create json)
		uc.execute()
		#console.log phase

# export to root object
root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel