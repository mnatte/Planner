# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

# TODO: ADD 'DELETE' FUNCTIONALITY FOR PHASES AND RELEASES. MOVE TO TREE STRUCTURE OF RELEASES, FACTOR OUT PHASES

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

	refreshRelease: (oldElement, jsonData) =>
		# remove item from array
		rel = (a for a in @allReleases() when a.id is oldElement.id)[0]
		console.log rel
		parentrel = (a for a in @allReleases() when a.id is oldElement.parentId)[0]
		console.log parentrel
		@allReleases.remove(rel)
		@allReleases.remove(parentrel)
		# insert newly loaded release when available
		if jsonData is not null and jsonData is not undefined
			i = if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)
			rel = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath)
			for phase in jsonData.Phases
				rel.addPhase new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id)
			@allReleases.splice i, 0, rel

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
		#rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		#console.log rel
		#parentrel = (a for a in @allReleases() when a.id is @selectedRelease().parentId)[0]
		#console.log parentrel
		#i = if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)
		#@allReleases.remove(rel)
		#@allReleases.remove(parentrel)

		@selectedRelease().save("/planner/Release/Save", ko.toJSON(@selectedRelease()), (data) => @refreshRelease(@selectedRelease(), data))
			#rel = new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath)
			#for phase in data.Phases
				#rel.addPhase new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id)
			#@allReleases.splice i, 0, rel)
	
	deleteRelease: (data) =>
		console.log "deleteRelease: #{data.id}"
		#console.log @allReleases()
		
		if data.parentId is undefined
			rel = (a for a in @allReleases() when a.id is data.id)[0]
			refreshId = data.id
		else
			parentrel = (a for a in @allReleases() when a.id is data.parentId)[0]
			rel = (a for a in parentrel.phases when a.id is data.id)[0]
			refreshId = data.parentId
		console.log "rel: #{rel}"

		rel.delete("/planner/Release/Delete/" + rel.id, (callbackdata) =>
			console.log callbackdata
			rel.get("/planner/Release/GetReleaseSummaryById/"+ refreshId, (jsonData) => @refreshRelease(rel, jsonData))
		)
		
# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel