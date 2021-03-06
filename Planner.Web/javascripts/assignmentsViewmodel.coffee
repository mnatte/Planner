# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class AssignmentsViewmodel
	constructor: (@allResources) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		#@selectedPhase = ko.observable()
		#@canShowDetails = ko.observable(false)
		# enable persistence of instances of Period (absences)
		Period.extend RCrud
		Period.extend RPeriodSerialize
		Resource.extend RTeamMember
		#@allResources = ko.observableArray(allResources)
		@showResources = ko.observableArray(@allResources)
		@includeResources = ko.observableArray()

		@selectedTimelineItem = ko.observable()
		@selectedAbsence = ko.observable()
		# observable for 'modify absences' dialog. also passed to UModifyAbsences usecase
		@dialogAbsences = ko.observable()

		@selectedAssignment = ko.observable()
		#@selectedResource = ko.observable()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			#@selectedAbsence newValue.dataObject
			#@selectedResource newValue.dataObject.person
			if newValue.dataObject.type() is "Period"
				console.log "is Period"
				@selectedAbsence newValue.dataObject
			)
		@selectedAbsence.subscribe((newValue) => 
			console.log newValue
			callback = (data) => @refreshTimeline(data)
			uc = new UModifyAbsences(@selectedAbsence, @allResources, callback, @dialogAbsences)
			uc.execute()
			)
		#@selectedResource.subscribe((newValue) =>
			#console.log 'selectedResource changed: ' + newValue.fullName()
			#)
		@includeResources.subscribe((newValue) => 
			console.log newValue
			include = newValue.reduce (acc, x) =>
							#console.log x
							resource = r for r in @allResources when +r.id is +x
							#console.log resource
							acc.push resource
						 acc
					, []
			@showResources(include)
			)
		weekLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 7 ) # 7 = amt days
		threeMonthsLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 90 ) # 90 = amt days
		@checkPeriod = ko.observable(new Period(new Date(), threeMonthsLater))
		@checkPeriod.subscribe((newValue) =>
			#console.log 'dateview changed: ' + newValue
			@load(@showResources().sort())
			#drawTimeline(@showAssignments, @selectedTimelineItem)
			timeline = new Mnd.Timeline(@showAssignments, @selectedTimelineItem)
			timeline.draw()
			)
		@showResources.subscribe((newValue) =>
			console.log 'showResources changed: ' + newValue
			@load(@showResources().sort())
			#drawTimeline(@showAssignments, @selectedTimelineItem)
			timeline = new Mnd.Timeline(@showAssignments, @selectedTimelineItem)
			timeline.draw()
			)


	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@displayData = []
		#console.log data
		for resource in data
			#console.log resource.fullName()
			i = 0
			for absence in (abs for abs in resource.periodsAway when abs.overlaps(@checkPeriod())) # resource.periodsAway
				dto = absence
				dto.person = resource
				obj = {group: resource.fullName() + '[' + i + ']', start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: dto}
				@displayData.push obj
				i++
			for assignment in (ass for ass in resource.assignments when ass.period.overlaps(@checkPeriod())) #resource.assignments
				dto = assignment
				dto.person = resource
				obj = {group: resource.fullName() + '[' + i + ']', start: assignment.period.startDate.date, end: assignment.period.endDate.date, content: assignment.period.title, info: assignment.period.toString() + '(' + assignment.remainingAssignedHours() + ' hrs remaining)', dataObject: dto}
				@displayData.push obj
				i++
		@showAssignments = @displayData.sort((a,b)-> a.start - b.end)


	updatePeriod: (data) =>
		# we only have dateString for use, not the entire DatePlus object. Therefore instantiate a new Period and update Period observable checkPeriod
		period = new Period(DateFormatter.createFromString(@checkPeriod().startDate.dateString), DateFormatter.createFromString(@checkPeriod().endDate.dateString))
		@checkPeriod period

	mailPlanning: (model) ->
		ajx = new Ajax
		ajx.mailPlanning("/planner/Resource/Assignments/Mail", ko.toJSON(@checkPeriod()), (data) => @afterMail(data))

	afterMail: (data) =>
		console.log data

	refreshTimeline: (newItem) =>
		console.log "refreshTimeline"
		index = -1 # index set for new absences
		if @selectedAbsence().id > 0 # update of existing absence
			timelineItem = a for a in @displayData when a.dataObject is @selectedAbsence()
			index = @displayData.indexOf(timelineItem)
		console.log index
		console.log newItem
		# check whether the returned json is an absence or just a message
		if newItem.StartDate
			absence = Period.create newItem
			#console.log newItem.Person.Id
			#console.log @allResources
			absence.person = p for p in @allResources when +p.id is +newItem.Person.Id
			timelineItem = {group: absence.person.fullName(), start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: absence}
			#console.log absence
			console.log timelineItem
			if index > -1
				# index = index of item to remove, 1 is amount to be removed, timelineItem is item to be inserted there
				@showAssignments.splice index, 1, timelineItem
			else
				@showAssignments.splice index, 0, timelineItem
			@selectedTimelineItem timelineItem
		else
			# just remove item from timeline
			# index = index of item to remove, 1 is amount to be removed, timelineItem is item to be inserted there
			@showAssignments.splice index, 1
		timeline = new Mnd.Timeline(@showAssignments, @selectedTimelineItem)
		timeline.draw()
		# set dialog data to null, dialog binding closes the dialog
		@dialogAbsences null

# export to root object
root.AssignmentsViewmodel = AssignmentsViewmodel