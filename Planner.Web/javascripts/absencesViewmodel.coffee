# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AbsencesViewmodel
	constructor: (allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		# enable persistence of instances of Period (absences)
		Resource.extend RTeamMember
		@selectedTimelineItem = ko.observable()
		@selectedAbsence = ko.observable()
		# observable for 'modify absences' dialog. also passed to UModifyAbsences usecase
		@dialogAbsences = ko.observable()
		@allResources = ko.observableArray(allResources)

		updateScreenFunctions = []
		updateScreenFunctions.push((data) => @refreshTimeline(data))
		@updateScreenUseCase = new UUpdateScreen(null, updateScreenFunctions)

		@selectedTimelineItem.subscribe((newValue) => 
			#console.log newValue
			@selectedAbsence newValue.dataObject
			)
		
		@selectedAbsence.subscribe((newValue) =>
			#console.log newValue
			#callback = (data) => @refreshTimeline(data)
			uc = new UModifyAbsences(@selectedAbsence, @allResources, @updateScreenUseCase, @dialogAbsences)
			#uc = new UModifyAbsences(@selectedAbsence, @allResources, callback, @dialogAbsences)
			uc.execute()
			)

	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@displayData = []
		#console.log data
		for resource in data
			#console.log resource.fullName()
			for absence in resource.periodsAway
				dto = absence
				dto.person = resource
				obj = {group: resource.fullName(), start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: dto}
				@displayData.push obj
		@showAbsences = @displayData.sort((a,b)-> a.start - b.end)

	newAbsence: =>
		newAbsence = new Period(new Date(), new Date(), 'New Absence', 0)
		newAbsence.id = 0
		@selectedAbsence newAbsence

	refreshTimeline: (newItem) =>
		console.log "refreshTimeline"
		index = -1 # index set to 0 for new absences
		if @selectedAbsence().id > 0 # update of existing absence, set personId
			timelineItem = a for a in @displayData when a.dataObject is @selectedAbsence()
			index = @displayData.indexOf(timelineItem)
		console.log index
		console.log newItem
		# check whether the returned json is an absence or just a message
		if newItem.StartDate
			absence = Period.create newItem
			absence.person = p for p in @allResources() when +p.id is +newItem.Person.Id
			timelineItem = {group: absence.person.fullName(), start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: absence}
			#console.log absence
			console.log timelineItem
			if index > -1
				# index = index of item to remove, 1 is amount to be removed, timelineItem is item to be inserted there
				@showAbsences.splice index, 1, timelineItem
			else
				@showAbsences.splice index, 0, timelineItem
			@selectedTimelineItem timelineItem
		else
			# just remove item from timeline
			# index = index of item to remove, 1 is amount to be removed, timelineItem is item to be inserted there
			@showAbsences.splice index, 1
		timeline = new Mnd.Timeline(@showAbsences, @selectedTimelineItem)
		timeline.draw()
		# set dialog data to null, dialog binding closes the dialog
		@dialogAbsences null

	createVisualCuesForAbsences: (data) =>
		uc = new UCreateVisualCuesForAbsences 30, (data) => console.log 'callback succesful: ' + data
		uc.execute()

# export to root object
root.AbsencesViewmodel = AbsencesViewmodel