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
		@showCheckboxes = ko.observable(true)
		@checkPeriod = ko.observable(new Period(new Date(), new Date()))

		#@includeResources.subscribe((newValue) =>
		#	console.log newValue
		#)
		#@checkPeriod.subscribe((newValue) =>
		#	console.log newValue
		#)
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


# export to root object
root.ResourceAvailabilityViewmodel = ResourceAvailabilityViewmodel