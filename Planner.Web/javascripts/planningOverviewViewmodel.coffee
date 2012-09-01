# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PhasesViewmodel
	constructor: ->
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
		console.log @periodToView()
	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE (this) here 
		@resources = []
		for resources in data.Resources
			# fill release object
			# console.log release
			res = new Resource(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title)
			# add phases
			for phase in release.Phases
				# console.log phase
				rl.addPhase new Phase(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title)
			rl.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
			@releases.push rl
			# console.log "this.releases: #{@releases}"
		@releases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
		for phase in @releases when phase.overlaps(@periodToView())
			@currentPhases.push phase

		@absences = []
		for absence in data.Absences
			# fill release object
			# console.log release
			abs = new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Person)
			@absences.push abs

		# @selectedPhase(@releases[0])
		@overlappingAbsences = ko.computed(=> 
				a = []
				for abs in @absences when abs.overlaps(@selectedPhase())
					# console.log "overlaps: #{abs}"
					a.push(abs)
				a
		, this)

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

	currentAbsences: ->
		current = []
		for abs in @absences when abs.isCurrent()
			current.push abs
		current

	selectPhase: (data) =>
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

# export to root object
root.PhasesViewmodel = PhasesViewmodel