# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AbsencesViewmodel
	constructor: (@allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		#@selectedPhase = ko.observable()
		#@canShowDetails = ko.observable(false)
		# enable persistence of instances of Period (absences)
		Period.extend RCrud
		Period.extend RPeriodSerialize
		Resource.extend RTeamMember
		@selectedTimelineItem = ko.observable()
		@selectedAbsence = ko.observable()
		@selectedResource = ko.observable()
		#@absences = ko.observableArray()
		@currentModal = ko.observable(null)

		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			@selectedAbsence newValue.dataObject
			@selectedResource newValue.dataObject.person
			)
		@selectedResource.subscribe((newValue) =>
			console.log 'selectedResource changed: ' + newValue.fullName()
			)

		@selectedAbsence.subscribe((newValue) =>
			console.log newValue
			@currentModal({ name: 'absenceForm', data: newValue})
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

	setAssignments: (jsonData) =>
		@assignments.removeAll()
		@assignments AssignedResource.createCollection(jsonData)

	loadAssignments: (releaseId) ->
        ajax = new Ajax()
        ajax.getAssignedResourcesForRelease(releaseId, @setAssignments)
		
	closeDetails: =>
        @canShowDetails(false)

	refreshTimeline: (index, newItem) =>
		console.log "refreshTimeline"
		#console.log index
		#console.log newItem
		absence = Period.create newItem
		absence.person = p for p in @allResources when p.id is newItem.Person.Id
		timelineItem = {group: absence.person.fullName(), start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: absence}
		#console.log absence
		console.log timelineItem
		if index > -1
			# index = index of item to remove, 1 is amount to be removed, newItem is item to be inserted there
			@showAbsences.splice index, 1, timelineItem
		else
			@showAbsences.splice index, 0, timelineItem

		#timeline.addItem(timelineItem)
		#timeline.deleteItem(index)
		#timeline.redraw
		@selectedTimelineItem timelineItem
		#drawTimeline(@showAbsences, @selectedTimelineItem)
		timeline = new Mnd.Timeline(@showAbsences, @selectedTimelineItem)
		timeline.draw()

	saveSelectedAbsence: =>
		i = -1 # index set to 0 for new absences
		absence = @selectedAbsence() # set object to persist
		if @selectedAbsence().id > 0 # update of existing absence, set personId
			timelineItem = a for a in @displayData when a.dataObject is @selectedAbsence()
			i = @displayData.indexOf(timelineItem)
			absence.personId = absence.person.id
			delete absence.person
		else
			absence.personId = @selectedResource().id
		console.log ko.toJSON(absence)
		@selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(absence), (data) => @refreshTimeline(i, data))

	deleteSelectedAbsence: =>
		console.log @selectedAbsence()
		abs = (a for a in @showAbsences when a.dataObject.id is @selectedAbsence().id)[0]
		# use index for removing from @allReleases
		i = @showAbsences.indexOf(abs)
		console.log 'index: ' + i
		@selectedAbsence().delete("/planner/Resource/DeleteAbsence/" + @selectedAbsence().id, (callbackdata) =>
			# check for server error is done in Roles.coffee RCrud delete method
			console.log callbackdata
			@showAbsences.splice i, 1
			next = @showAbsences[i]
			console.log next
			@selectedTimelineItem next
			$.unblockUI()
		)

	newAbsence: =>
		newAbsence = new Period(new Date(), new Date(), 'New Absence', 0)
		newAbsence.id = 0
		@selectedAbsence newAbsence
		console.log @selectedAbsence()

	createVisualCuesForAbsences: (data) =>
		uc = new UCreateVisualCuesForAbsences 30, (data) => console.log 'callback succesful: ' + data
		uc.execute()

# export to root object
root.AbsencesViewmodel = AbsencesViewmodel