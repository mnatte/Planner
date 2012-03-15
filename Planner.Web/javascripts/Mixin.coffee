# access (for browser)
root = global ? window

moduleKeywords = ['extended', 'included']

class Mixin
	@extend: (obj) ->
		for key, value of obj when key not in moduleKeywords
			# @ refers to this and that is now a static object
			# all properties (incl. functions) of the extension are added as a static method
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

class DateFormatter
	# static function, @ is static at this moment
	@formatJsonDate: (dateJson, format) ->
		console.log "formatJsonDate: #{dateJson} with format #{format}"
		$.format.date(@createJsDateFromJson(dateJson), format)
	@createJsDateFromJson: (dateJson) ->
		eval("new " + dateJson.slice(1, -1))
	@formatJsDate: (date, format) ->
		$.format.date(date, format)

# export to root object
root.Mixin = Mixin
root.DateFormatter = DateFormatter