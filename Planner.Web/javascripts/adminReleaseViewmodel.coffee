# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminReleaseViewmodel
	constructor: (@allReleases) ->
		Release.extend(RCrud)
		console.log @allReleases
		@selectedRelease = ko.observable()

	selectRelease: (data) =>
		console.log "selectRelease - function"
		# console.log @
		# console.log data
		@selectedRelease(data)
		console.log "selectRelease after selection: " + @selectedRelease().title

	clear: ->
		console.log "clear: selectedRelease: #{@selectedRelease().title}"
		@selectRelease new Release("", "", "", "")

	saveSelected: =>
		console.log "saveSelected: selectedRelease: #{@selectedRelease()}"
		console.log ko.toJSON(@selectedRelease())
		# @selectedRelease().save("/planner/Release/Save", ko.toJSON(@selectedRelease()), alert "saved!")

# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel