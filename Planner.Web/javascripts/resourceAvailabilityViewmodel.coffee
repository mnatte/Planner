# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ResourceAvailabilityViewmodel
	constructor: (@allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches all props and functions to all instances (since object IS ctor)
		Resource.extend RTeamMember
		#@allResources = ko.observableArray(allResources)
		@includeResources = ko.observableArray()
		@inspectResource = ko.observable()
		@showCheckboxes = ko.observable(true)
		monthLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 30 ) # 30 = amt days
		@checkPeriod = ko.observable(new Period(new Date(), monthLater))

		#@includeResources.subscribe((newValue) =>
		#	console.log newValue
		#)
		@checkPeriod.subscribe((newValue) =>
			@inspectResource()
		)
		@totalHoursAvailable = ko.computed(=> 
			total = (res for res in @includeResources()).reduce (acc, x) =>
					#console.log 'computed total'
					#console.log x
					resource = r for r in @allResources when +r.id is +x
					#console.log resource
					result = resource.availableHoursForPlanning(@checkPeriod())
					acc + result
				, 0
			total
		, this)

	checkAvailability: (data) =>
		# console.log @checkPeriod()
		# we only have dateString for use, not the entire DatePlus object. Therefore instantiate a new Period and update Period observable checkPeriod
		period = new Period(DateFormatter.createFromString(@checkPeriod().startDate.dateString), DateFormatter.createFromString(@checkPeriod().endDate.dateString))
		@checkPeriod period

	inspectOverplanning: (resource) =>
		console.log resource
		resWithAssAndAbsInDate = resource
		resWithAssAndAbsInDate.assignments = (a for a in resource.assignments when a.period.overlaps(@checkPeriod()))
		resWithAssAndAbsInDate.periodsAway = (a for a in resource.periodsAway when a.overlaps(@checkPeriod()))
		@inspectResource resWithAssAndAbsInDate


# export to root object
root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel