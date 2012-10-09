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
			@setObservables rel
		@allReleases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)

	setObservables: (rel) ->
		@setReleaseProjects rel
		do (rel) ->
			# console.log "ctor sort rel: #{rel}"
			rel.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		@setMilestones rel
		for ms in rel.milestones()
			@setMilestoneDeliverables ms
		@setPhases rel

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
				#console.log "assign deliverable #{m.title}"
				ms.deliverables.push m
		console.log ms

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
		if jsonData != null and jsonData != undefined
			console.log "jsonData not undefined:"
			console.log jsonData
			rel = Release.create jsonData
			#@setReleaseProjects rel
			#for ms in rel.milestones
			#	@setMilestoneDeliverables ms
			#@setPhases rel
			@setObservables rel
			rel.phases.sort((a,b)->a.startDate.date - b.startDate.date)
			rel.milestones.sort((a,b)->a.date.date - b.date.date)

			# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
			@allReleases.splice i, 1, rel

	clear: ->
		@formType "release"
		#console.log "clear: selectedRelease: #{@selectedRelease().title}"
		release = new Release(0, new Date(), new Date(), "", "")
		@setObservables release
		@selectRelease release

	addPhase: (data) =>
		@formType "phase"
		
		allPhasesArr = @allReleases().reduce (acc, x) ->
					acc.push x.phases()
					acc
				, []

		allPhases = allPhasesArr.reduce (acc, x) ->
					# when using concat the original array (acc, is '[]' here) never changes. concat returns a new array as result
					result = acc.concat x
					result
				, []

		maxId = allPhases.reduce (acc, x) ->
					max = if acc > x.id then acc else x.id
					max
				,0
		newId = maxId + 1

		@selectPhase new Phase(newId, new Date(), new Date(), "", "", @selectedRelease().id)
		console.log "selectedPhase: #{ko.toJSON(@selectedPhase())}"
		#console.log "selectedRelease id: #{@selectedRelease().id}"

	removePhase: (data) =>
		phase = (a for a in @selectedRelease().phases() when a.id is data.id)[0]
		i = @selectedRelease().phases().indexOf(phase)
		# add phaseId to graph
		#assignment = @selectedMilestone()
		#assignment.phaseId = @selectedRelease().id
		@selectedRelease().phases.splice(i, 1)

	addNewMilestone: (release) =>
		@formType "milestone"

		allMilestonesArr = @allReleases().reduce (acc, x) ->
					acc.push x.milestones()
					acc
				, []

		allMilestones = allMilestonesArr.reduce (acc, x) ->
					# when using concat the original array (acc, is '[]' here) never changes. concat returns a new array as result
					result = acc.concat x
					result
				, []

		#console.log allMilestones
		maxId = allMilestones.reduce (acc, x) ->
					max = if acc > x.id then acc else x.id
					max
				,0
		newId = maxId + 1
		newMs = new Milestone(newId, new Date(), "0:00", "New Milestone", "", @selectedRelease().id)
		@setMilestoneDeliverables newMs
		@selectedMilestone newMs
		#console.log release
		console.log @selectedMilestone()

	unAssignMilestone: (milestone) =>
		#@formType "milestone"
		#@selectedMilestone milestone
		console.log milestone
		#console.log @selectedMilestone()
		#parentrel = (a for a in @allReleases() when a.id is @selectedMilestone().phaseId)[0]
		#i = @allReleases().indexOf(parentrel)
		ms = (a for a in @selectedRelease().milestones() when a.id is milestone.id)[0]
		i = @selectedRelease().milestones().indexOf(ms)
		# add phaseId to graph
		# assignment = @selectedMilestone()
		# assignment.phaseId = @selectedRelease().id
		@selectedRelease().milestones.splice(i, 1)
		#@selectedMilestone().save("/planner/Release/UnAssignMilestone", ko.toJSON(assignment), (data) => @selectedRelease().milestones.splice(i, 1))

	saveSelected: =>
		console.log "saveSelected"

		# TODO: generate optimal serialized object
		# project id's with basic properties, phase id's with basic properties, milestone id's with basic properties and with deliverable id's
		# processing of the entire graph will go through Release aggregate / repository

		# get clean copy, replacing all observables with their values
		release = ko.toJS(@selectedRelease())
		#console.log release
		# use extra custom serialization for only relevant config properties
		# ko.toJSON calls the toJSON method of all objects. this is done on the snapshot instance
		graph = ko.toJSON(release.toConfigurationSnapshot())

		# serialized graph:
		#{"id":130,"startDate":"06/10/2012","endDate":"06/10/2012","title":"Test","tfsIterationPath":""
		#	,"phases":[
		#		{"id":130,"startDate":"07/10/2012","endDate":"07/10/2012","title":"Phase 1","tfsIterationPath":"","parentId":130}
		#	]
		#	,"projects":[
		#		{"id":1,"title":"EU Maintenance","shortName":"EU","descr":"","tfsIterationPath":"","tfsDevBranch":"Dev-5"}
		#		,{"id":2,"title":"APAC","shortName":"APAC","descr":"","tfsIterationPath":"NLBEESD-VFS-PM\\Release 9.2\\APAC","tfsDevBranch":"Dev-2"}
		#	]
		#	,"milestones":[
		#		{"id":35,"time":"0:00","title":"New Milestone","description":"","phaseId":130,"date":"07/10/2012"
		#			,"deliverables":[
		#				1,2
		#			]
		#		}
		#	]
		#}

		#console.log ko.isObservable(@selectedRelease().projects)
		rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		#parentrel = (a for a in @allReleases() when a.id is @selectedRelease().parentId)[0]
		#i = if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)
		#@selectedRelease().save("/planner/Release/Save", graph, (data) => @refreshRelease(i, data))
		i = @allReleases().indexOf(rel)
		@selectedRelease().save("/planner/Release/SaveReleaseConfiguration", graph, (data) => @refreshRelease(i, data))

	saveSelectedPhase: =>
		console.log "saveSelectedPhase: selectedRelease: #{@selectedRelease()}"
		console.log "saveSelectedPhase: selectedPhase: #{@selectedPhase()}"
		console.log ko.toJSON(@selectedPhase())
		console.log ko.toJSON(@selectedPhase().parentId)
		# rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		#parentrel = (a for a in @allReleases() when a.id is @selectedPhase().parentId)[0]
		#i = @allReleases().indexOf(parentrel) #if @allReleases().indexOf(rel) is -1 then @allReleases().indexOf(parentrel) else @allReleases().indexOf(rel)

		phase = (a for a in @selectedRelease().phases() when a.id is @selectedPhase().id)[0]
		if(typeof(phase) is "undefined" || phase is null || phase.id is 0) then @selectedRelease().addPhase(@selectedPhase())
		#@selectedPhase().save("/planner/Release/Save", ko.toJSON(@selectedPhase()), (data) => @selectedRelease().phases.push(@selectedPhase()))

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
		dels = ko.toJSON(@selectedMilestone().deliverables())
		console.log dels
		# add milestone to release when new
		if(typeof(ms) is "undefined" || ms is null || ms.id is 0) then @selectedRelease().addMilestone(@selectedMilestone())
		#@selectedMilestone().save("/planner/Release/SaveMilestone", ko.toJSON(@selectedMilestone()), (data) => newMs = Milestone.create data;newMs.phaseId = @selectedRelease().id; @setMilestoneDeliverables newMs;if(typeof(ms) is "undefined" || ms is null || ms.id is 0) then @selectedRelease().addMilestone(newMs))
	
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