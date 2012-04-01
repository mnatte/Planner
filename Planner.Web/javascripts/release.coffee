# access (for browser)
root = global ? window

	# '@' is shortcut for 'this'. Unlike C#, 'this' refers to 'this context', which can be different every time a function is called
	
	# 'new' says: don't return result of function, just create new object and run function in object's context
	# all properties are part of the prototype, except the constructor

	# Phase is an object; it is actually the constructor function
	# '@' insists that the property is attached to the class object itself

	# functions attached to the prototype are invoked in the context of the individual object
	# @-variables within those functions refer to the instance properties because the '@' context IS the object instance: e.g. phase.workingHours()

class Phase extends Mixin
	# attach seperate startDate, endDate and title properties to each instance
	constructor: (@id, @startDate, @endDate, @title, @tfsIterationPath) ->
		@startDateString = DateFormatter.formatJsDate(@startDate, 'dd-MM-yyyy')
		@endDateString = DateFormatter.formatJsDate(@endDate, 'dd-MM-yyyy')
	workingDays: ->
		days = 0
		# console.log "days: #{days}"
		msPerDay = 86400 * 1000
		# '@' refers to object instance
		@startDate.setHours(0,0,0,1)
		@endDate.setHours(23,59,59,59,999)
		diff = @endDate - @startDate
		days = Math.ceil(diff / msPerDay)
		# console.log "days: #{days}"
		weeks = Math.floor(days / 7)
		days = days - (weeks * 2)
		# console.log "days: #{days}"
		startDay = @startDate.getDay()
		endDay = @endDate.getDay()
		days = days - 2 if (startDay - endDay > 1)
		# console.log "days: #{days}"
		days = days - 1 if (startDay == 0 and endDay != 6)
		# console.log "days: #{days}"
		days = days - 1 if (endDay == 6 and startDay != 0)
		# console.log "days: #{days}"
		days
	workingHours: ->
		@workingDays() * 8
	toString: ->
		"#{@title} #{DateFormatter.formatJsDate(@startDate, 'dd/MM/yyyy')} - #{DateFormatter.formatJsDate(@endDate, 'dd/MM/yyyy')} (#{@workingDays()} working days)"
	isCurrent: ->
		today = new Date()
		today >= @startDate and today < @endDate
	isFuture: ->
		today = new Date()
		today < @startDate
	isPast: ->
		today = new Date()
		today > @startDate
	overlaps: (other) ->
		# console.log "other: #{other}"
		unless other is undefined
			# console.log (@startDate >= other.startDate and @startDate < other.endDate) or (@endDate >= other.startDate and @endDate < other.endDate)
			(@startDate >= other.startDate and @startDate < other.endDate) or (@endDate >= other.startDate and @endDate < other.endDate)

class MileStone
	constructor: (@date, @title) ->

class Release extends Phase
	constructor: (@startDate, @endDate, @title, @tfsIterationPath) ->
		# pass along all args to parent ctor by using 'super' instead of 'super()'
		super
		@phases = []
		@backlog = []
		@resources = []
	addPhase: (phase) ->
		@phases.push(phase)
	addFeature: (feature) ->
		@backlog.push(feature)
	addResource: (resource) ->
		# console.log resource.initials + "->" + resource.memberProject
		@resources.push(resource)

class Absence extends Phase
	constructor: (@startDate, @endDate, @title, @resource) ->
		# pass along all args to parent ctor by using 'super' instead of 'super()'

class Feature
	constructor: (@businessId, @contactPerson, @estimatedHours, @hoursWorked, @priority, @project, @remainingHours, @title, @state) ->
	
class Resource extends Mixin
	constructor: (@firstName, @middleName, @lastName, @initials, @hoursPerWeek, @function) ->
		@periodsAway = []
	addAbsence: (period) ->
		@periodsAway.push(period)

	
# export to root object
root.Phase = Phase
root.MileStone = MileStone
root.Release = Release
root.Absence = Absence
root.Feature = Feature
root.Resource = Resource

