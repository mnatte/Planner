# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PhasesViewmodel
	constructor: ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedPhase = ko.observable()
		@canShowDetails = ko.observable(false)
	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@releases = []
		for release in data.Releases
			# fill release object
			# console.log release
			rl = new Release(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title)
			# add phases
			for phase in release.Phases
				# console.log phase
				rl.addPhase new Phase(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title)
			rl.phases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)
			@releases.push rl
			# console.log "this.releases: #{@releases}"
		@releases.sort((a,b)-> if a.startDate.date > b.startDate.date then 1 else if a.startDate.date < b.startDate.date then -1 else 0)

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
			
	currentPhases: ->
		current = []
		for phase in @releases when phase.isCurrent()
			current.push phase
		current

	closeDetails: =>
        @canShowDetails(false)

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