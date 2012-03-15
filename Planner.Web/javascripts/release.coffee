# access (for browser)
root = global ? window

class Phase extends Mixin
	constructor: (@startDate, @endDate, @title) ->
	workingDays: ->
		days = 0
		# console.log "days: #{days}"
		msPerDay = 86400 * 1000
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

class MileStone
	constructor: (@date, @title) ->

class Release extends Phase
	constructor: (@startDate, @endDate, @workingDays, @title) ->
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
		console.log resource.initials + "->" + resource.memberProject
		@resources.push(resource)

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
root.Feature = Feature
root.Resource = Resource
