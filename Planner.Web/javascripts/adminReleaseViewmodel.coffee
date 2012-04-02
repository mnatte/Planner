# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminReleaseViewmodel
	constructor: (allReleases) ->
		Release.extend(RCrud)
		@selectedRelease = ko.observable()
		@allReleases = ko.observableArray(allReleases)
		console.log @allReleases
		# @selectedRelease.subscribe( (newValue) -> alert 'selectedRelease changed with ' + newValue)

	selectRelease: (data) =>
		console.log "selectRelease - function"
		# console.log @
		# console.log data
		@selectedRelease data
		console.log "selectRelease after selection: " + @selectedRelease().title

	clear: ->
		console.log "clear: selectedRelease: #{@selectedRelease().title}"
		@selectRelease new Release(0, new Date(), new Date(), "", "")

	saveSelected: =>
		console.log "saveSelected: selectedRelease: #{@selectedRelease()}"
		console.log ko.toJSON(@selectedRelease())
		# TODO: replace existing item with this one or add it when new to @allReleases

		@selectedRelease().save("/planner/Release/Save", ko.toJSON(@selectedRelease()), (data) => @allReleases.push new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath))

# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel