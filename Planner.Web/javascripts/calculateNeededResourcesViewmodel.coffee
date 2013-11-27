# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class CalculateNeededResourcesViewmodel
	constructor: (@deliverable, period, focusFactor) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		# needed: Deliverable instance (with scope and workload (workload is an array of ProjectActivityStatus instances) etc.) named 'deliverable'
		# needed: Period instance named 'period'
		# needed: Double instance named 'focusFactor'

		console.log deliverable
		console.log period
		console.log focusFactor
		@period = ko.observable(period)
		@focusFactor = ko.observable()
		@resourcesNeeded = ko.observable()

		@focusFactor.subscribe((newValue) => 
			console.log newValue
			@resourcesNeeded(@calculateResourcesNeeded(@deliverable))
			)

		@period.subscribe((newValue) => 
			console.log newValue
			@resourcesNeeded(@calculateResourcesNeeded(@deliverable))
			)

		# set 1 observable after declaring the subscriptions so that @resourcesNeeded gets filled
		@focusFactor focusFactor

	calculateResourcesNeeded: (deliverable) => 
		#console.log 'calculateResourcesNeeded!'
		#console.log deliverable
		if deliverable and deliverable.scope
			hoursRemaining = 0
			for sc in deliverable.scope
				hrs = sc.workload.reduce (acc, x) =>
								#console.log x.hoursRemaining
								#console.log acc
								# make sure numbers are added (not strings) by putting a '+' before 'x.hoursRemaining'
								acc + +x.hoursRemaining
							, 0
				hoursRemaining += hrs
			#console.log hoursRemaining

			effectiveResourceHoursPerDay = @focusFactor() * 8
			availableWorkingHours = @period().remainingWorkingDays() * effectiveResourceHoursPerDay
			fteNeeded = (hoursRemaining / availableWorkingHours).toFixed(2)
			fteNeeded

	datesChanged: (data) =>
		# we only have dateString for use, not the entire DatePlus object. Therefore instantiate a new Period and update Period observable checkPeriod
		period = new Period(DateFormatter.createFromString(@period().startDate.dateString), DateFormatter.createFromString(@period().endDate.dateString))
		@period period

# export to root object
root.CalculateNeededResourcesViewmodel = CalculateNeededResourcesViewmodel