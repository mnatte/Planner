# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AbsencesViewmodel
	constructor: (allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		#@selectedPhase = ko.observable()
		#@canShowDetails = ko.observable(false)
		# enable persistence of instances of Period (absences)
		Period.extend RCrud
		Period.extend RPeriodSerialize
		Resource.extend RTeamMember
		@selectedTimelineItem = ko.observable()
		@selectedAbsence = ko.observable()
		#@absences = ko.observableArray()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			@selectedAbsence newValue.dataObject
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
				dto.personId = resource.id
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
		person = Resource.createSnapshot newItem.Person
		timelineItem = {group: person.fullName(), start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: absence}
		#console.log absence
		console.log timelineItem
		# index = index of item to remove, 1 is amount to be removed, newItem is item to be inserted there
		@showAbsences.splice index, 1, timelineItem

		#timeline.addItem(timelineItem)
		#timeline.deleteItem(index)
		timeline.redraw
		@selectedTimelineItem timelineItem
		#drawTimeline(@showAbsences, @selectedTimelineItem)

	saveSelectedAbsence: =>
		console.log ko.toJSON(@selectedAbsence())
		timelineItem = a for a in @displayData when a.dataObject is @selectedAbsence()
		i = @displayData.indexOf(timelineItem)
		@selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(@selectedAbsence()), (data) => @refreshTimeline(i, data))

# export to root object
root.AbsencesViewmodel = AbsencesViewmodel