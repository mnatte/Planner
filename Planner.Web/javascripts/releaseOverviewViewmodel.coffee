# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseOverviewViewmodel
	constructor: (allReleases, @allResources, @allActivities) ->
		# ctor is executed in context of INSTANCE. Therefore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@inspectRelease = ko.observable()
		@selectedMilestone = ko.observable()
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
		#@inspectRelease.subscribe((newValue) => 
		#	console.log newValue
		#	)
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
			)
		# used for update selected assignment
		@selectedTimelineItem = ko.observable()
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
		updateScreenUseCases.push(new UDisplayReleaseTimeline(@inspectRelease, @selectedMilestone))
		# @selectedTimelineItem is the observable to trigger selected assignment functionality
		updateScreenUseCases.push(new UDisplayReleasePlanningInTimeline(@inspectRelease, @selectedTimelineItem))
		updateScreenFunctions.push(=> @selectedTimelineItem null)
		updateScreenFunctions.push(=> @selectedMilestone null)
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
		console.log @selectedMilestone().dataObject.date.dateString
		console.log @selectedMilestone().dataObject.time
		console.log @selectedMilestone().dataObject.id
		console.log @selectedMilestone().dataObject.title
		console.log @selectedMilestone().dataObject.release.title
		console.log @selectedMilestone().dataObject.release.id
		date = DateFormatter.createFromString @selectedMilestone().dataObject.date.dateString
		ms = new Milestone(@selectedMilestone().dataObject.id, date, @selectedMilestone().dataObject.time, null, null, @selectedMilestone().dataObject.release.id)
		uc = new URescheduleMilestone(ms, @allReleases, @inspectRelease, @updateScreenUseCase, @selectedAssignment, (json) -> Release.create json)
		uc.execute()

# export to root object
root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel