# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminReleaseViewmodel
	constructor: (allReleases, allProjects) ->
		# setup nice 'remove' method for Array
		Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

		Release.extend(RCrud)
		@selectedRelease = ko.observable()
		@allReleases = ko.observableArray(allReleases)
		@allProjects = ko.observableArray(allProjects)

		#@allNumbers = ko.observableArray([1,2,3,4,5])
		@testNumbers = ko.observableArray([])
		#@selectedProjectIds = ko.observableArray([])
		for rel in @allReleases()
			@setReleaseProjects rel
			# console.log rel.projects()
			# console.log ko.isObservable(rel.projects)
			console.log ko.isWriteableObservable(rel.projects)
			do (rel) ->
				# console.log "ctor sort rel: #{rel}"
				rel.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		@allReleases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)

		#console.log @allProjects()

	setReleaseProjects: (rel) ->
		# assign projects and transform projects array to observableArray so changes will be registered
			# use slice to create independent copy instead of copying the reference by relprojs = rel.projects
			relprojs = rel.projects.slice()
			rel.projects = ko.observableArray([])
			for proj in relprojs
				#console.log proj
				for p in @allProjects() when p.id is proj.id
					#console.log "assign project #{p.title}"
					rel.projects.push p		

	selectRelease: (data) =>
		console.log "selectRelease - function"
		# console.log @
		# console.log data
		@selectedRelease data
		#@selectedProjectIds.removeAll()
		#for proj in @selectedRelease().projects
			#@selectedProjectIds.push(proj.id)
		console.log @selectedRelease().projects()
		#console.log "selectRelease after selection: " + @selectedRelease().title + ", parentId: " +  @selectedRelease().parentId

	refreshRelease: (index, jsonData) =>
		# use given index or take new index ('length' is one larger than max index) when item is not in @allReleases (value is -1). 
		# when not in @allReleases, the item is new and will be inserted at the end. no item will be removed prior to adding it.
		i = if index >= 0 then index else @allReleases().length
		# console.log "index: #{index}"
		# console.log "i: #{i}"
		
		# i = index of item to remove, 1 is amount to be removed
		@allReleases.splice(i,1)
		# insert newly loaded release when available
		console.log jsonData
		if jsonData != null and jsonData != undefined
			console.log "jsonData not undefined"
			rel = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath)
			for phase in jsonData.Phases
				rel.addPhase new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id)
			# index = index of item to remove, 0 is amount to be removed, rel is item to be inserted there
			rel.phases.sort((a,b)->a.startDate.date - b.startDate.date)

			for project in jsonData.Projects
				rel.addProject new Project(project.Id, project.Title, project.ShortName)
				# use slice to create independent copy instead of copying the reference by relprojs = rel.projects
				@setReleaseProjects rel

				#relprojs = rel.projects.slice()
				#rel.projects = ko.observableArray([])
				#for proj in relprojs
				#	console.log proj
				#	for p in @allProjects() when p.id is proj.id
				#		console.log "assign project #{p.title}"
				#		rel.projects.push p
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
		console.log ko.isObservable(@selectedRelease().projects)
		rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		parentrel = (a for a in @allReleases() when a.id is @selectedRelease().parentId)[0]
		i = if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)
		@selectedRelease().save("/planner/Release/Save", ko.toJSON(@selectedRelease()), (data) => @refreshRelease(i, data))
	
	deleteRelease: (data) =>
		if data.parentId is undefined
			rel = (a for a in @allReleases() when a.id is data.id)[0]
			id = data.id
			# use index for removing from @allReleases
			i = @allReleases().indexOf(rel)
		else
			parentrel = (a for a in @allReleases() when a.id is data.parentId)[0]
			rel = (a for a in parentrel.phases when a.id is data.id)[0]
			id = data.parentId
			# use i as parent index for refreshing in @allReleases
			i = @allReleases().indexOf(parentrel)

		rel.delete("/planner/Release/Delete/" + rel.id, (callbackdata) =>
			console.log callbackdata
			rel.get("/planner/Release/GetReleaseSummaryById/"+ id, (jsonData) => @refreshRelease(i, jsonData))
		)

# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel