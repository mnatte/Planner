# access (for browser)
root = global ? window

moduleKeywords = ['extended', 'included']

class Mixin
	@extend: (obj) ->
		for key, value of obj when key not in moduleKeywords
			# @ refers to this and that is now a static object
			@[key] = value
	
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

# export to root object
root.Mixin = Mixin