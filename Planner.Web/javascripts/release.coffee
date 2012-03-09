# access (for browser)
root = global ? window

class Phase extends Mixin
	constructor: (@startDate, @endDate, @workingDays, @title) ->
		@workingHours = @workingDays * 8
	toString: ->
		"#{@title} #{@startDate} - #{@endDate} (#{@workingDays} working days)"

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
