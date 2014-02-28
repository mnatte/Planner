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
		@selectedAbsence = ko.observable()
		@selectedResource = ko.observable()
		# observable for 'modify assignments' dialog. also passed to UModifyResourceAssignment usecase
		@dialogAssignments = ko.observable()
		@dialogAbsences = ko.observable()

		updateScreenUseCases = []
		#updateScreenUseCases.push(new URefreshView(@inspectResource, @checkPeriod()))
		updateScreenFunctions = []
		updateScreenFunctions.push(() => @inspectResource null)
		@updateScreenUseCase = new UUpdateScreen(updateScreenUseCases, updateScreenFunctions)

		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			if newValue.assignment
				aap = newValue.assignment
				aap.resourceName = newValue.resource.fullName()
				aap.resourceId = newValue.resource.id
				console.log newValue.assignment
				@selectedAssignment newValue.assignment
			if newValue.absence
				@selectedAbsence newValue.absence
			)
		@selectedAssignment.subscribe((newValue) =>
			console.log 'selectedAssignment changed'
			console.log newValue
			#console.log @allResources()
			if newValue
				# console.log @updateScreenUseCase
				# @selectedAssignment, @allResourcesObservable, @updateViewUseCase, @dialogObservable
				uc = new UModifyResourceAssignment(@selectedAssignment, @allResources, @updateScreenUseCase, @dialogAssignments)
				uc.execute()
			)
		@selectedAbsence.subscribe((newValue) =>
			console.log 'selectedAbsence changed'
			console.log newValue
			#console.log @allResources()
			if newValue
				callback = (data) => @inspectResource null
				# constructor: (@selectedAbsence, @allResources, @updateViewUseCase, @dialogObservable) ->
				uc = new UModifyAbsences(@selectedAbsence, @allResources, @updateScreenUseCase, @dialogAbsences)
				uc.execute()
			)
		@allResources.subscribe((newValue) =>
			console.log 'allResources changed: ' + newValue
			)

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

	#saveSelectedAssignment: =>
		# data to persist, observableCollection to refresh, observable to refresh, callback to refresh screen, observable to hide form, dehydration method for callback
		# useCase = new UModifyAssignment(@selectedAssignment(), @allResources, @inspectResource, @updateScreenUseCase, @selectedAssignment, "resource", (json) -> Resource.create json)
	#	useCase = new UModifyResourceAssignment(@selectedAssignment, @allResources, @inspectResource, @updateScreenUseCase, @selectedAssignment)
	#	useCase.execute()

	#deleteSelectedAssignment: =>
	#	useCase = new UDeleteAssignment(@selectedAssignment(), @allResources, @inspectResource, @updateScreenUseCase, @selectedAssignment, "resource", (json) -> Resource.create json)
	#	useCase.execute()

# export to root object
root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel