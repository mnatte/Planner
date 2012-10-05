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

		for rel in @allReleases()
			@setReleaseProjects rel
			do (rel) ->
				# console.log "ctor sort rel: #{rel}"
				rel.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
			@setMilestones rel
			for ms in rel.milestones()
				@setMilestoneDeliverables ms
			@setPhases rel
		@allReleases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)

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
		#console.log "setMilestoneDeliverables to observableArray"
		# assign deliverables and transform deliverables array to observableArray so changes will be registered
		msDels = ms.deliverables.slice() # use slice to create independent copy instead of copying the reference through msDels = ms.deliverables
		#console.log msDels
		ms.deliverables = ko.observableArray([])
		for del in msDels
			#console.log del
			for m in @allDeliverables() when m.id is del.id
				#console.log "assign deliverable #{m.title}"
				ms.deliverables.push m
		#console.log ms

	setPhases: (rel) =>
		#console.log "setPhases to observableArray"
		# assign deliverables and transform deliverables array to observableArray so changes will be registered
		phases = rel.phases.slice() # use slice to create independent copy
		rel.phases = ko.observableArray(phases)
		#console.log rel.phases()

	setMilestones: (rel) =>
		#console.log "setPhases to observableArray"
		# assign deliverables and transform deliverables array to observableArray so changes will be registered
		milestones = rel.milestones.slice() # use slice to create independent copy
		rel.milestones = ko.observableArray(milestones)
		#console.log rel.phases()

	# functions for observable necessary to pass view model data to it from html
	selectRelease: (data) =>
		#console.log "selectRelease - function"
		@formType "release"
		@selectedRelease data
		#console.log @selectedRelease().phases()
		#console.log "selectRelease - done"

	selectPhase: (data) =>
		@formType "phase"
		@selectedPhase data

	selectMilestone: (data) =>
		@formType "milestone"
		@selectedMilestone data
		console.log @selectedMilestone()

	refreshRelease: (index, jsonData) =>
		# use given index or take new index ('length' is one larger than max index) when item is not in @allReleases (value is -1). 
		# when not in @allReleases, the item is new and will be inserted at the end. no item will be removed prior to adding it.
		i = if index >= 0 then index else @allReleases().length
		console.log "index: #{index}"
		console.log "i: #{i}"
		# insert newly loaded release when available
		console.log jsonData
		if jsonData != null and jsonData != undefined
			console.log "jsonData not undefined"
			rel = Release.create jsonData
			@setReleaseProjects rel
			for ms in rel.milestones
				@setMilestoneDeliverables ms
			@setPhases rel
			rel.phases.sort((a,b)->a.startDate.date - b.startDate.date)
			rel.milestones.sort((a,b)->a.date.date - b.date.date)

			# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
			@allReleases.splice i, 1, rel

	clear: ->
		@formType "release"
		#console.log "clear: selectedRelease: #{@selectedRelease().title}"
		release = new Release(0, new Date(), new Date(), "", "")
		@setReleaseProjects release
		@selectRelease release

	addPhase: (data) =>
		@formType "phase"
		@selectPhase new Release(0, new Date(), new Date(), "", "", @selectedRelease().id)
		console.log "selectedPhase: #{ko.toJSON(@selectedPhase())}"
		console.log "selectedRelease id: #{@selectedRelease().id}"

	addNewMilestone: (release) =>
		@formType "milestone"
		@selectedMilestone new Milestone(0, new Date(), "0:00", "", "", @selectedRelease().id)
		#console.log release
		@setMilestoneDeliverables @selectedMilestone()
		console.log @selectedMilestone()

	unAssignMilestone: (milestone) =>
		#@formType "milestone"
		@selectedMilestone milestone
		console.log milestone
		console.log @selectedMilestone()
		#parentrel = (a for a in @allReleases() when a.id is @selectedMilestone().phaseId)[0]
		#i = @allReleases().indexOf(parentrel)
		ms = (a for a in @selectedRelease().milestones() when a.id is milestone.id)[0]
		i = @selectedRelease().milestones().indexOf(ms)
		@selectedMilestone().save("/planner/Release/UnAssignMilestone", ko.toJSON(@selectedMilestone()), (data) => @selectedRelease().milestones.splice(i, 1))

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
		@selectedPhase().save("/planner/Release/Save", ko.toJSON(@selectedPhase()), (data) => @selectedRelease().phases.push(@selectedPhase()))

	saveSelectedMilestone: =>
		#console.log "saveSelectedMilestone: selectedRelease: #{@selectedRelease()}"
		#console.log "saveSelectedMilestone: selectedMilestone: #{@selectedMilestone()}"
		console.log ko.toJSON(@selectedMilestone())
		#console.log ko.toJSON(@selectedMilestone().phaseId)
		#callback = @selectedRelease().milestones.push(@selectedMilestone())
		ms = (a for a in @selectedRelease().milestones() when a.id is @selectedMilestone().id)[0]
		#if(typeof(ms) is not "undefined" && ms is not null)
			#console.log ms
			#callback = 'undefined'
		@selectedMilestone().save("/planner/Release/SaveMilestone", ko.toJSON(@selectedMilestone()), (data) => newMs = Milestone.create data;@setMilestoneDeliverables newMs;if(typeof(ms) is "undefined" || ms is null || ms.id is 0) then @selectedRelease().milestones.push(newMs))
	
	deleteRelease: (data) =>
		console.log 'deleteRelease'
		console.log data
		isRelease = data.parentId is undefined
		if isRelease
			rel = (a for a in @allReleases() when a.id is data.id)[0]
			id = data.id
			# use index for removing from @allReleases
			i = @allReleases().indexOf(rel)
		else
			parentrel = (a for a in @allReleases() when a.id is data.parentId)[0]
			console.log parentrel
			rel = (a for a in parentrel.phases() when a.id is data.id)[0]
			console.log rel
			id = data.parentId
			# use i as parent index for refreshing in @allReleases
			#i = @allReleases().indexOf(parentrel)

		rel.delete("/planner/Release/Delete/" + rel.id, (callbackdata) =>
			if isRelease
				# console.log callbackdata
				# i = index of item to remove, 1 is amount to be removed
				@allReleases.splice i, 1
				next = @allReleases()[i]
				console.log next
				@selectRelease next
			else
				phase = (a for a in @selectedRelease().phases when a.id is data.id)[0]
				i = @selectedRelease().phases.indexOf(phase)
				@selectedRelease().phases.splice i, 1
		)

# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel