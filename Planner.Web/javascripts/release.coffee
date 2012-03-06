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
	addPhase: (phase) ->
		@phases.push(phase)
	addFeature: (feature) ->
		@backlog.push(feature)

class Feature
	constructor: (@businessId, @contactPerson, @estimatedHours, @hoursWorked, @priority, @project, @remainingHours, @title) ->
	
# export to root object
root.Phase = Phase
root.MileStone = MileStone
root.Release = Release
root.Feature = Feature
