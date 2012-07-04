# access (for browser)
root = global ? window

moduleKeywords = ['extended', 'included']

class Mixin
	@extend: (obj) ->
		for key, value of obj when key not in moduleKeywords
			# @ refers to this and that is now a static object because of JS inheritance strategy through 'extends'
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
		#console.log dateJson
		eval("new " + dateJson.slice(1, -1))
	@formatJsDate: (date, format) ->
		$.format.date(date, format)
	@createFromString: (string) ->
		#yyyy,mm,dd
		#new Date(2011,10,30)
		new Date(getDateFromFormat(string, "dd/MM/yyyy"))

class DatePlus
	constructor: (@date) ->
		@dateString = $.format.date(date, 'dd/MM/yyyy')

# export to root object
root.Mixin = Mixin
root.DateFormatter = DateFormatter
root.DatePlus = DatePlus