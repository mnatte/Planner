# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ResourceAvailabilityViewmodel
	constructor: (allResources) ->
		console.log allResources
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches all props and functions to all instances (since object IS ctor)
		Resource.extend RTeamMember
		Assignment.extend RAssignmentSerialize
		Assignment.extend RCrud
		@allResources = ko.observableArray(allResources)
		@includeResources = ko.observableArray()
		@inspectResource = ko.observable()
		monthLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 30 ) # 30 = amt days
		@checkPeriod = ko.observable(new Period(new Date(), monthLater))
		@selectedTimelineItem = ko.observable()
		@selectedAssignment = ko.observable()
		@selectedResource = ko.observable()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			aap = newValue.assignment
			aap.resourceName = newValue.resource.fullName()
			aap.resourceId = newValue.resource.id
			console.log newValue.assignment
			@selectedAssignment newValue.assignment
			)
		@selectedAssignment.subscribe((newValue) =>
			console.log 'selectedAssignment changed: ' + newValue#.period
			)
		@allResources.subscribe((newValue) =>
			console.log 'allResources changed: ' + newValue
			)
		updateScreenUseCases = []
		updateScreenUseCases.push(new URefreshView(@inspectResource, @checkPeriod()))
		@updateScreenUseCase = new UUpdateScreen updateScreenUseCases

		@checkPeriod.subscribe((newValue) =>
			@inspectResource()
		)
		@totalHoursAvailable = ko.computed(=> 
			total = (res for res in @includeResources()).reduce (acc, x) =>
					resource = r for r in @allResources() when +r.id is +x
					result = resource.availableHoursForPlanning(@checkPeriod())
					acc + result
				, 0
			total
		, this)

	checkAvailability: (data) =>
		# we only have dateString for use, not the entire DatePlus object. Therefore instantiate a new Period and update Period observable checkPeriod
		period = new Period(DateFormatter.createFromString(@checkPeriod().startDate.dateString), DateFormatter.createFromString(@checkPeriod().endDate.dateString))
		@checkPeriod period

	inspectOverplanning: (resource) =>
		# only bring in the overlapping periods to the graph
		console.log resource
		resWithAssAndAbsInDate = resource
		resWithAssAndAbsInDate.assignments = (a for a in resource.assignments when a.period.overlaps(@checkPeriod()))
		resWithAssAndAbsInDate.periodsAway = (a for a in resource.periodsAway when a.overlaps(@checkPeriod()))
		@inspectResource resWithAssAndAbsInDate
		@selectedAssignment null

	saveSelectedAssignment: =>
		# data to persist, observableCollection to refresh, observable to refresh, callback to refresh screen, observable to hide form, dehydration method for callback
		useCase = new UModifyAssignment(@selectedAssignment(), @allResources, @inspectResource, @updateScreenUseCase, @selectedAssignment, "resource", (json) -> Resource.create json)
		useCase.execute()

	deleteSelectedAssignment: =>
		useCase = new UDeleteAssignment(@selectedAssignment(), @allResources, @inspectResource, @updateScreenUseCase, @selectedAssignment, "resource", (json) -> Resource.create json)
		useCase.execute()

# export to root object
root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel