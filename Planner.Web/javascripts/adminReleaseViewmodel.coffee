# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AdminReleaseViewmodel
	constructor: (allReleases, allProjects, allDeliverables) ->
		# setup nice 'remove' method for Array
		Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

		Phase.extend(RCrud)
		Milestone.extend(RCrud)
		@selectedRelease = ko.observable()
		@selectedPhase = ko.observable()
		@selectedMilestone = ko.observable()
		@formType = ko.observable("release")
		@allReleases = ko.observableArray(allReleases)
		@allProjects = ko.observableArray(allProjects)
		@allDeliverables = ko.observableArray(allDeliverables)

		#@allNumbers = ko.observableArray([1,2,3,4,5])
		@testNumbers = ko.observableArray([])
		#@selectedProjectIds = ko.observableArray([])
		for rel in @allReleases()
			@setReleaseProjects rel
			# console.log rel.projects()
			# console.log ko.isObservable(rel.projects)
			# console.log ko.isWriteableObservable(rel.projects)
			do (rel) ->
				# console.log "ctor sort rel: #{rel}"
				rel.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
			for ms in rel.milestones
				@setMilestoneDeliverables ms
		@allReleases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)

		#console.log @allProjects()

	setReleaseProjects: (rel) ->
		# assign projects and transform projects array to observableArray so changes will be registered
			relprojs = rel.projects.slice() # use slice to create independent copy instead of copying the reference by relprojs = rel.projects
			rel.projects = ko.observableArray([])
			for proj in relprojs
				#console.log proj
				for p in @allProjects() when p.id is proj.id
					#console.log "assign project #{p.title}"
					rel.projects.push p		

	setMilestoneDeliverables: (ms) ->
		console.log "setMilestoneDeliverables to observableArray"
		# assign deliverables and transform deliverables array to observableArray so changes will be registered
		msDels = ms.deliverables.slice() # use slice to create independent copy instead of copying the reference through msDels = ms.deliverables
		console.log msDels
		ms.deliverables = ko.observableArray([])
		for del in msDels
			#console.log del
			for m in @allDeliverables() when m.id is del.id
				console.log "assign deliverable #{m.title}"
				ms.deliverables.push m
		console.log ms

	# functions for observable necessary to pass view model data to it from html
	selectRelease: (data) =>
		console.log "selectRelease - function"
		@formType "release"
		# console.log @
		# console.log data
		@selectedRelease data
		#@selectedProjectIds.removeAll()
		#for proj in @selectedRelease().projects
			#@selectedProjectIds.push(proj.id)
		console.log @selectedRelease().projects()
		#console.log "selectRelease after selection: " + @selectedRelease().title + ", parentId: " +  @selectedRelease().parentId

	selectPhase: (data) =>
		@formType "phase"
		@selectedPhase data

	selectMilestone: (data) =>
		@formType "milestone"
		@selectedMilestone data
		#@setMilestoneDeliverables @selectedMilestone()
		console.log @selectedMilestone()

	refreshRelease: (index, jsonData) =>
		# use given index or take new index ('length' is one larger than max index) when item is not in @allReleases (value is -1). 
		# when not in @allReleases, the item is new and will be inserted at the end. no item will be removed prior to adding it.
		i = if index >= 0 then index else @allReleases().length
		console.log "index: #{index}"
		console.log "i: #{i}"
		
		# i = index of item to remove, 1 is amount to be removed
		@allReleases.splice(i,1)
		# insert newly loaded release when available
		console.log jsonData
		if jsonData != null and jsonData != undefined
			console.log "jsonData not undefined"
			rel = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath)
			for phase in jsonData.Phases
				rel.addPhase new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, rel.id)
			for milestone in jsonData.Milestones
				ms = Milestone.create(milestone, rel.id)
				@setMilestoneDeliverables ms
				rel.addMilestone ms
			# index = index of item to remove, 0 is amount to be removed, rel is item to be inserted there
			rel.phases.sort((a,b)->a.startDate.date - b.startDate.date)
			rel.milestones.sort((a,b)->a.date.date - b.date.date)

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
		@formType "release"
		#console.log "clear: selectedRelease: #{@selectedRelease().title}"
		@selectRelease new Release(0, new Date(), new Date(), "", "")

	addPhase: (data) =>
		@formType "phase"
		@selectPhase new Release(0, new Date(), new Date(), "", "", data.id)
		console.log "selectedRelease parentId: #{@selectedRelease().parentId}"

	addNewMilestone: (release) =>
		@formType "milestone"
		@selectedMilestone new Milestone(0, new Date(), "0:00", "", "", release.id)
		#console.log release

	unAssignMilestone: (milestone) =>
		#@formType "milestone"
		@selectedMilestone milestone
		console.log milestone
		console.log @selectedMilestone()
		parentrel = (a for a in @allReleases() when a.id is @selectedMilestone().phaseId)[0]
		i = @allReleases().indexOf(parentrel)
		@selectedMilestone().save("/planner/Release/UnAssignMilestone", ko.toJSON(@selectedMilestone()), (data) => @refreshRelease(i, data))

	saveSelected: =>
		console.log "saveSelected: selectedRelease: #{@selectedRelease()}"
		console.log ko.toJSON(@selectedRelease())
		#console.log ko.isObservable(@selectedRelease().projects)
		rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		parentrel = (a for a in @allReleases() when a.id is @selectedRelease().parentId)[0]
		i = if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)
		@selectedRelease().save("/planner/Release/Save", ko.toJSON(@selectedRelease()), (data) => @refreshRelease(i, data))

	saveSelectedPhase: =>
		console.log "saveSelectedPhase: selectedRelease: #{@selectedRelease()}"
		console.log "saveSelectedPhase: selectedPhase: #{@selectedPhase()}"
		console.log ko.toJSON(@selectedPhase())
		console.log ko.toJSON(@selectedPhase().parentId)
		# rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		parentrel = (a for a in @allReleases() when a.id is @selectedPhase().parentId)[0]
		i = @allReleases().indexOf(parentrel) #if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)
		@selectedPhase().save("/planner/Release/Save", ko.toJSON(@selectedPhase()), (data) => @refreshRelease(i, data))

	saveSelectedMilestone: =>
		console.log "saveSelectedMilestone: selectedRelease: #{@selectedRelease()}"
		console.log "saveSelectedMilestone: selectedMilestone: #{@selectedMilestone()}"
		console.log ko.toJSON(@selectedMilestone())
		console.log ko.toJSON(@selectedMilestone().phaseId)
		parentrel = (a for a in @allReleases() when a.id is @selectedMilestone().phaseId)[0]
		i = @allReleases().indexOf(parentrel)
		@selectedMilestone().save("/planner/Release/SaveMilestone", ko.toJSON(@selectedMilestone()), (data) => @refreshRelease(i, data))
	
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