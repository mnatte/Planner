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
		
		# setup nice 'remove' method for Array
		Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

	selectRelease: (data) =>
		console.log "selectRelease - function"
		# console.log @
		# console.log data
		@selectedRelease data
		console.log "selectRelease after selection: " + @selectedRelease().title + ", parentId: " +  @selectedRelease().parentId

	clear: ->
		console.log "clear: selectedRelease: #{@selectedRelease().title}"
		@selectRelease new Release(0, new Date(), new Date(), "", "")

	addPhase: (data) =>
		@selectRelease new Release(0, new Date(), new Date(), "", "", data.id)
		console.log "selectedRelease parentId: #{@selectedRelease().parentId}"

	saveSelected: =>
		console.log "saveSelected: selectedRelease: #{@selectedRelease()}"
		console.log ko.toJSON(@selectedRelease())
		# console.log @allReleases()
		rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		console.log rel
		parentrel = (a for a in @allReleases() when a.id is @selectedRelease().parentId)[0]
		console.log parentrel
		@allReleases.remove(rel)
		@allReleases.remove(parentrel)
		# TODO: replace existing item with this one or add it when new to @allReleases

		@selectedRelease().save("/planner/Release/Save", ko.toJSON(@selectedRelease()), (data) => 
			rel = new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath)
			for phase in data.Phases
				rel.addPhase new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id)
			@allReleases.push rel)

# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel