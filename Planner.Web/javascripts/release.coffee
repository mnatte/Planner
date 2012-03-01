# access (for browser)
root = global ? window

moduleKeywords = ['extended', 'included']

class Mixin
	# @methodname are "static" methods: @ refers to this, so Mixin.extend() can be called
	@extend: (obj) ->
		for key, value of obj when key not in moduleKeywords
			# @ refers to this and that is now a static object
			@[key] = value
			# console.log "#{key} -> #{value}"
	
		# if 'extended' function (callback) exists on obj, apply it to this
		obj.extended?.apply(@)
		this

	@include: (obj) ->
		for key, value of obj when key not in moduleKeywords
			# Assign to prototype, making it instance properties for all instances
			@::[key] = value

		# if 'included' function (callback) exists on obj, apply it to this
		obj.included?.apply(@)
		this

class Phase extends Mixin
	constructor: (@startDate, @endDate, @workingDays, @title) ->
		@workingHours = @workingDays * 8

class MileStone
	constructor: (@date, @title) ->

class Release extends Phase
	constructor: (@startDate, @endDate, @workingDays, @title) ->
		# pass along all args to parent ctor by using 'super' instead of 'super()'
		super
		@phases = []
	addPhase: (phase) ->
		@phases.push(phase)

# export to root object
root.Phase = Phase
root.MileStone = MileStone
root.Release = Release
