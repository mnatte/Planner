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
		# we use Roles here for serialization, where you could consider the viewmodel to be a use case
		Milestone.extend(RMilestoneSerialize)
		Release.extend(RReleaseSerialize)
		Project.extend(RProjectSerialize)
		Period.extend(RPeriodSerialize)
		Phase.extend(RPhaseSerialize)
		@selectedRelease = ko.observable()
		@selectedPhase = ko.observable()
		@selectedMilestone = ko.observable()
		@formType = ko.observable("release")
		@allReleases = ko.observableArray(allReleases)
		@allProjects = ko.observableArray(allProjects)
		@allDeliverables = ko.observableArray(allDeliverables)
		@itemToDelete = ko.observable()

		for rel in @allReleases()
			@setObservables rel
		@allReleases.sort((a,b)->a.startDate.date - b.startDate.date)

	setObservables: (rel) ->
		@setReleaseProjects rel
		do (rel) ->
			# console.log "ctor sort rel: #{rel}"
			rel.phases.sort((a,b)->a.startDate.date - b.startDate.date)
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
		# insert newly loaded release when available
		if jsonData != null and jsonData != undefined
			#console.log "jsonData not undefined:"
			#console.log jsonData
			rel = Release.create jsonData
			@setObservables rel
			rel.phases.sort((a,b)->a.startDate.date - b.startDate.date)
			rel.milestones.sort((a,b)->a.date.date - b.date.date)

			# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
			@allReleases.splice i, 1, rel
			@selectRelease rel

	clear: ->
		@formType "release"
		#console.log "clear: selectedRelease: #{@selectedRelease().title}"
		release = new Release(0, new Date(), new Date(), "", "")
		@setObservables release
		@selectRelease release

	addPhase: (data) =>
		@formType "phase"
		
		allPhasesArr = @allReleases().reduce (acc, x) ->
					acc.push [x]
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
		console.log milestone
		ms = (a for a in @selectedRelease().milestones() when a.id is milestone.id)[0]
		i = @selectedRelease().milestones().indexOf(ms)
		@selectedRelease().milestones.splice(i, 1)

	saveSelected: =>
		console.log "saveSelected"
		# get clean copy, replacing all observables with their values
		
		#release = ko.toJS(@selectedRelease())
		#console.log release
		# use extra custom serialization for only relevant config properties
		# ko.toJSON calls the toJSON method of all objects. this is done on the snapshot instance
		#graph = ko.toJSON(release.toConfigurationSnapshot())

		rel = (a for a in @allReleases() when a.id is @selectedRelease().id)[0]
		i = @allReleases().indexOf(rel)
		# console.log @selectedRelease().phases()
		# console.log @selectedRelease().toConfigurationSnapshotJson()
		@selectedRelease().save("/planner/Release/SaveReleaseConfiguration", @selectedRelease().toConfigurationSnapshotJson(), (data) => @refreshRelease(i, data))

	saveSelectedPhase: =>
		#console.log "saveSelectedPhase: selectedPhase: #{@selectedPhase()}"
		#console.log ko.toJSON(@selectedPhase())
		phase = (a for a in @selectedRelease().phases() when a.id is @selectedPhase().id)[0]
		if(typeof(phase) is "undefined" || phase is null || phase.id is 0) then @selectedRelease().addPhase(@selectedPhase())

	saveSelectedMilestone: =>
		#console.log "saveSelectedMilestone: selectedMilestone: #{@selectedMilestone()}"
		#console.log ko.toJSON(@selectedMilestone())
		ms = (a for a in @selectedRelease().milestones() when a.id is @selectedMilestone().id)[0]
		# add milestone to release when new
		if(typeof(ms) is "undefined" || ms is null || ms.id is 0) then @selectedRelease().addMilestone(@selectedMilestone())
	
	confirmDelete: =>
		@deleteRelease @itemToDelete(), $.unblockUI()

	setItemToDelete: (item) =>
		@itemToDelete item
		$.blockUI({ css: {
            border: 'none',
            padding: '15px',
            backgroundColor: '#000',
            '-webkit-border-radius': '10px',
            '-moz-border-radius': '10px',
            opacity: .5,
            color: '#fff'
			},
			message: $('#question')
			})
	
	deleteRelease: (data) =>
		console.log 'deleteRelease'
		console.log data
		rel = (a for a in @allReleases() when a.id is data.id)[0]
		id = data.id
		# use index for removing from @allReleases
		i = @allReleases().indexOf(rel)
		rel.delete("/planner/Release/Delete/" + rel.id, (callbackdata) =>
			# check for server error is done in Roles.coffee RCrud delete method
			@allReleases.splice i, 1
			next = @allReleases()[i]
			console.log next
			@selectRelease next
			$.unblockUI()
		)

# export to root object
root.AdminReleaseViewmodel = AdminReleaseViewmodel