# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseOverviewViewmodel
	constructor: (allReleases, @allResources, @allActivities) ->
		# ctor is executed in context of INSTANCE. Therefore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@inspectRelease = ko.observable()
		@selectedMilestone = ko.observable()
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
			x = newValue.dataObject
			x.releaseName = @inspectRelease().title
			x.milestoneName = newValue.dataObject.title
			x.period = new Period(new Date(), newValue.dataObject.date.date, "planned period")
			x.focusFactor = 0.8
			@newAssignment x
			)
		# used for update selected assignment
		@selectedTimelineItem = ko.observable()
		@selectedAssignment = ko.observable()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			x = newValue.dataObject
			x.resourceName = newValue.dataObject.resource.fullName()
			x.resourceId = newValue.dataObject.resource.id
			#x.period = newValue.dataObject.assignedPeriod
			console.log x
			@selectedAssignment x
			)
		Resource.extend RTeamMember
		Assignment.extend RAssignmentSerialize
		Assignment.extend RCrud

	viewReleasePlanning: (selectedRelease) =>
		console.log selectedRelease
		@inspectRelease selectedRelease
		# @selectedMilestone is the observable to trigger new assignment functionality
		uc = new UDisplayReleaseTimeline(selectedRelease, @selectedMilestone)
		uc.execute()
		# @selectedTimelineItem is the observable to trigger selected assignment functionality
		uc2 = new UDisplayReleasePlanningInTimeline(@inspectRelease, @selectedTimelineItem)
		uc2.execute()

	saveSelectedAssignment: =>
		# 2nd parameter null will be filled in the callback of the UModifyResourceAssignment usecase with new Release instance from server data
		updateUc = new UDisplayReleasePlanningInTimeline(@inspectRelease, @selectedTimelineItem)
		useCase = new UModifyAssignment(@selectedAssignment(), @allReleases, @inspectRelease, updateUc, @selectedAssignment)
		useCase.execute()

	saveNewAssignment: =>
		# 2nd parameter null will be filled in the callback of the UModifyResourceAssignment usecase with new Release instance from server data
		updateUc = new UDisplayReleasePlanningInTimeline(@inspectRelease, @selectedTimelineItem)
		useCase = new UModifyAssignment(@newAssignment(), @allReleases, @inspectRelease, updateUc, @newAssignment)
		useCase.execute()

	deleteSelectedAssignment: =>
		#useCase = new UDeleteResourceAssignment(@selectedAssignment(), @checkPeriod(), @inspectResource, @selectedAssignment, @allResources)
		# 2nd parameter null will be filled in the callback of the usecase with server data
		#updateUc = new URefreshView(@allResources, null, @checkPeriod(), @inspectResource, @selectedAssignment)
		#useCase = new UDeleteResourceAssignment(@selectedAssignment(), updateUc)
		#useCase.execute()

# export to root object
root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel