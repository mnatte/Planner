# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PhasesViewmodel
	constructor: (allReleases) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedPhase = ko.observable()
		@canShowDetails = ko.observable(false)
		@centerDate = ko.observable(new Date())
		@currentPhases = ko.observableArray()
		#console.log new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) )
		# centerDate minus 2 weeks
		startDate = new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) )
		# centerDate plus 4 weeks
		endDate =  new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) )
		@periodToView = ko.observable(new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period"))
		#console.log @periodToView()
	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@releases = []
		@displayData = []
		# for release in data.Releases
			# fill release object
		#	console.log release
		#	rl = new Release(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title)
			# add phases
		#	for phase in release.Phases
				# console.log phase
		#		rl.addPhase new Phase(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title)
		#	rl.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		#	@releases.push rl
			# console.log "this.releases: #{@releases}"
		#	for milestone in release.Milestones
		#		console.log milestone
		#		release.addMilestone Milestone.create(milestone, release.id)
		#data.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		#for rel in @releases when rel.overlaps(@periodToView())
		#	@currentPhases.push rel
		#	for ph in rel.phases when ph.overlaps(@periodToView())
		#		obj = {group: rel.title, start: ph.startDate.date, end: ph.endDate.date, content: ph.title, info: ''}
		#		@displayData.push obj
		#	for ms in rel.milestones when @periodToView().containsDate(ms.date.date)
		#		obj = {group: rel.title, start: ms.date.date, content: ph.title, info: 'test'}
		#		@displayData.push obj
		console.log data
		for rel in data #when rel.overlaps(@periodToView())
			console.log rel.title + ': ' + rel.endDate.dateString
			@currentPhases.push rel
			for ph in rel.phases #when ph.overlaps(@periodToView())
				obj = {group: rel.title, start: ph.startDate.date, end: ph.endDate.date, content: ph.title, info: ph.toString()}
				@displayData.push obj
			for ms in rel.milestones #when @periodToView().containsDate(ms.date.date)
				obj = {group: rel.title, start: ms.date.date, content: ms.title + '<br /><span class="icon icon-milestone" />', info: ms.date.dateString + '<br />' + ms.description}
				@displayData.push obj
		#@displayData.sort((a,b)-> if a.end > b.end then 1 else if a.end < b.end then -1 else 0)
		#console.log @displayData
		@showPhases = @displayData.sort((a,b)-> if a.end > b.end then 1 else if a.end < b.end then -1 else 0)

		#@absences = []
		#for absence in data.Absences
			# fill release object
			# console.log release
		#	abs = new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Person)
		#	@absences.push abs

		# @selectedPhase(@releases[0])
		#@overlappingAbsences = ko.computed(=> 
		#		a = []
		#		for abs in @absences when abs.overlaps(@selectedPhase())
		#			# console.log "overlaps: #{abs}"
		#			a.push(abs)
		#		a
		#, this)

		# console.log "this.absences: #{@absences}"
			
		#@currentPhases = ko.computed(=>
		#		console.log "currentPhases"
		#		current = []
		#		#console.log current
		#		for phase in @releases when phase.overlaps(@periodToView())
		#			#console.log @periodToView
		#			#console.log @viewPeriod()
		#			#console.log phase
		#			current.push phase
		#		current
		#, this)

	closeDetails: =>
        @canShowDetails(false)

	nextViewPeriod: ->
		@centerDate (new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 49)) )
		#console.log @centerDate()
		#console.log @periodToView()
		@periodToView new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period")
		#console.log @periodToView()
		@currentPhases.removeAll()
		for phase in @releases when phase.overlaps(@periodToView())
			@currentPhases.push phase

	prevViewPeriod: ->
		@centerDate (new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 49)) )
		#console.log @centerDate()
		#console.log @periodToView()
		@periodToView new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period")
		#console.log @periodToView()
		@currentPhases.removeAll()
		for phase in @releases when phase.overlaps(@periodToView())
			@currentPhases.push phase

	#viewPeriod: ->
		#@periodToView

	#currentAbsences: ->
	#	current = []
	#	for abs in @absences when abs.isCurrent()
	#		current.push abs
	#	current

	selectPhase: (data) =>
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

# export to root object
root.PhasesViewmodel = PhasesViewmodel