# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AbsencesViewmodel
	constructor: (allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		#@selectedPhase = ko.observable()
		#@canShowDetails = ko.observable(false)
		#@absences = ko.observableArray()
		#@selectedPhase.subscribe((newValue) => 
			#loadAssignments newValue.id
			#)

	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@resources = []
		@displayData = []
		console.log data
		for resource in data
			console.log resource.fullName()
			for absence in resource.periodsAway
				obj = {group: resource.fullName(), start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString()}
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

	selectPhase: (data) =>
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

# export to root object
root.AbsencesViewmodel = AbsencesViewmodel