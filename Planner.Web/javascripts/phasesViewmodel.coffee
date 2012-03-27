# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PhasesViewmodel
	constructor: ->
		@selectedPhase = ko.observable()
	load: (data) ->
		@releases = []
		for release in data.Releases
			# fill release object
			# console.log release
			rl = new Release(DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title)
			# add phases
			for phase in release.Phases
				# console.log phase
				rl.addPhase new Phase(DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title)
			@releases.push rl
			# console.log "this.releases: #{@releases}"

		@absences = []
		for absence in data.Absences
			# fill release object
			# console.log release
			abs = new Absence(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Person)
			@absences.push abs

		# @selectedPhase(@releases[0])
		@overlappingAbsences = ko.computed(=> 
				if(@selectedPhase is not undefined)
					sel = @selectedPhase
				else
					sel = @releases[0]
				console.log "sel: #{sel}"

				# WHY IS @selectedPhase AS A  FUNCTION OK HERE AND NOT ANYMORE DOWN AT THE check() function?

				@selectedPhase sel
				a = []
				console.log "selectedPhase: #{@selectedPhase()}"
				for abs in @absences when abs.overlaps(@selectedPhase())
					a.push(abs)
				a
			, this)

		console.log "this.absences: #{@absences}"
			
	# observable for selecting what to exclude from calculations
	@disgardedStatuses = ko.observableArray()
	@displaySelected = ko.computed(=> 
			console.log @
			console.log @disgardedStatuses()
			s = ""
			s += "#{item} - " for item in @disgardedStatuses()
			s 
		, this)

	currentPhases: ->
		current = []
		for phase in @releases when phase.isCurrent()
			current.push phase
		current

	currentAbsences: ->
		current = []
		for abs in @absences when abs.isCurrent()
			current.push abs
		current

	check: (data) ->
		@selectedPhase data
		console.log data

# export to root object
root.PhasesViewmodel = PhasesViewmodel