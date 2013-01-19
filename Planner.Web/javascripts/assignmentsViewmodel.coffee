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
		@selectedTimelineItem = ko.observable()
		@selectedAbsence = ko.observable()
		@selectedResource = ko.observable()
		#@absences = ko.observableArray()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			@selectedAbsence newValue.dataObject
			@selectedResource newValue.dataObject.person
			)
		@selectedResource.subscribe((newValue) =>
			console.log 'selectedResource changed: ' + newValue.fullName()
			)
		weekLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000 * 7 ) # 30 = amt days
		@checkPeriod = ko.observable(new Period(new Date(), weekLater))

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
				obj = {group: resource.fullName() + '[' + i + ']', start: assignment.period.startDate.date, end: assignment.period.endDate.date, content: assignment.period.title, info: assignment.period.toString(), dataObject: dto}
				@displayData.push obj
				i++
		@showAssignments = @displayData.sort((a,b)-> a.start - b.end)

	mailPlanning: (model) ->
		ajx = new Ajax
		ajx.mailPlanning("/planner/Resource/Assignments/Mail", ko.toJSON(@checkPeriod()), (data) => @afterMail(data))

	afterMail: (data) =>
		console.log data

# export to root object
root.AssignmentsViewmodel = AssignmentsViewmodel