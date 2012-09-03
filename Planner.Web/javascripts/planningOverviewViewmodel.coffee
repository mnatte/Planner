# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PlanningOverviewViewmodel
	constructor: (allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@allResources = ko.observableArray(allResources)
		@selectedPhase = ko.observable()
		# @canShowDetails = ko.observable(false)
		@centerDate = ko.observable(new Date())
		#console.log new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) )
		# centerDate minus 2 weeks
		startDate = new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) )
		# centerDate plus 4 weeks
		endDate =  new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) )
		@periodToView = ko.observable(new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period"))
		console.log @periodToView()
		@showResources = ko.observableArray()
		#@resourcesToShow = ko.observableArray()
		#@showResources.subscribe((newValue) =>
			#last = newValue.slice(-1)[0]
			#console.log last
		#)
		@resourcesToShow = ko.computed(=> 
			show = []
			for id in @showResources()
				for res in @allResources() when +res.id is +id 
					show.push res
			show
		, this)

	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here ('this' or '@')
		@resources = []
		for resource in data.Resources
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

		# console.log "this.absences: #{@absences}"
			
	
	# in this context we need '=>' to get to root viewmodel's centerDate() function. With '->', the '@' would refer to the Resource since that is the binding context (foreach: resources)
	nextViewPeriod: =>
		@centerDate (new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 49)) )
		#console.log @centerDate()
		#console.log @periodToView()
		@periodToView new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period")
		#console.log @periodToView()

	prevViewPeriod: =>
		@centerDate (new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 49)) )
		#console.log @centerDate()
		#console.log @periodToView()
		@periodToView new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period")
		#console.log @periodToView()

	currentAbsences: ->
		current = []
		for abs in @absences when abs.isCurrent()
			current.push abs
		current

# export to root object
root.PlanningOverviewViewmodel = PlanningOverviewViewmodel