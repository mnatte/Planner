# access (for browser)
root = global ? window

	# '@' is shortcut for 'this'. Unlike C#, 'this' refers to 'this context', which can be different every time a function is called
	
	# 'new' says: don't return result of function, just create new object and run function in object's context
	# all properties are part of the prototype, except the constructor

	# Phase is an object; it is actually the constructor function
	# '@' insists that the property is attached to the class object itself

	# functions attached to the prototype are invoked in the context of the individual object
	# @-variables within those functions refer to the instance properties because the '@' context IS the object instance: e.g. phase.workingHours()

#relies on datehelper.js
class Period extends Mixin
	# attach seperate startDate, endDate and title properties to each instance
	constructor: (startDate, endDate, @title, @id) ->
		# console.log "title: #{@title}"
		# console.log "startDate: #{startDate}"
		# console.log "endDate: #{endDate}"
		@startDate = new DatePlus(startDate)
		@endDate = new DatePlus(endDate)
	# FOR MAKING title OBSERVABLE IN PARENT VIEWMODELS USE:
	# constructor: (startDate, endDate, title) ->
		# @title = ko.observable(title)
	days: ->
		days = 0
		msPerDay = 86400 * 1000
		@startDate.date.setHours(0,0,0,1)
		@endDate.date.setHours(23,59,59,59,999)
		diff = @endDate.date - @startDate.date
		days = Math.ceil(diff / msPerDay)
		# console.log "days: #{days}"
		days
	workingDays: ->
		days = 0
		# console.log "days: #{days}"
		# console.log @
		#console.log "title: #{@title}"
		#console.log "startDate: #{@startDate}"
		#console.log "endDate: #{@endDate}"
		msPerDay = 86400 * 1000
		# '@' refers to object instance
		@startDate.date.setHours(0,0,0,1)
		@endDate.date.setHours(23,59,59,59,999)
		diff = @endDate.date - @startDate.date
		days = Math.ceil(diff / msPerDay)
		# console.log "days: #{days}"
		weeks = Math.floor(days / 7)
		days = days - (weeks * 2)
		# console.log "days: #{days}"
		startDay = @startDate.date.getDay()
		endDay = @endDate.date.getDay()
		days = days - 2 if (startDay - endDay > 1)
		# console.log "days: #{days}"
		days = days - 1 if (startDay == 0 and endDay != 6)
		# console.log "days: #{days}"
		days = days - 1 if (endDay == 6 and startDay != 0)
		# console.log "days: #{days}"
		days
	workingHours: ->
		@workingDays() * 8
	toString: ->
		"#{@title} #{@startDate.dateString} - #{@endDate.dateString} (#{@workingDays()} working days)"
	toShortString: ->
		"#{@startDate.format('dd/MM')} - #{@endDate.format('dd/MM')}"
	containsDate: (date) ->
		#console.log date
		#console.log @startDate.date
		#console.log @endDate.date
		date.setHours(0,0,0,0) >= @startDate.date.setHours(0,0,0,0) and date.setHours(0,0,0,0) <= @endDate.date.setHours(0,0,0,0)
	isCurrent: ->
		@containsDate(new Date())
	isFuture: ->
		today = new Date()
		today < @startDate.date
	isPast: ->
		today = new Date()
		today > @startDate.date
	startDaysFromNow: ->
		if @isFuture() 
			# The number of milliseconds in one day
			ONE_DAY = 1000 * 60 * 60 * 24
			# Convert both dates to milliseconds
			date1_ms = new Date().getTime()
			date2_ms = @startDate.date.getTime()
			# Calculate the difference in milliseconds
			difference_ms = Math.abs(date2_ms - date1_ms)
			# Convert back to days and return
			Math.round(difference_ms/ONE_DAY) 
		else 
			1
	remainingDays: ->
		# The number of milliseconds in one day
		ONE_DAY = 1000 * 60 * 60 * 24
		# Convert both dates to milliseconds
		date1_ms = new Date().getTime()
		date2_ms = @endDate.date.getTime()
		# Calculate the difference in milliseconds
		difference_ms = Math.abs(date1_ms - date2_ms)
		# Convert back to days and return
		Math.round(difference_ms/ONE_DAY)
	workingDaysRemaining: ->
		days = 0
		msPerDay = 86400 * 1000
		today = new Date()
		# '@' refers to object instance
		today.setHours(0,0,0,1)
		@endDate.date.setHours(23,59,59,59,999)
		diff = @endDate.date - today
		days = Math.ceil(diff / msPerDay)
		weeks = Math.floor(days / 7)
		days = days - (weeks * 2)
		startDay = today.getDay()
		endDay = @endDate.date.getDay()
		days = days - 2 if (startDay - endDay > 1)
		days = days - 1 if (startDay == 0 and endDay != 6)
		days = days - 1 if (endDay == 6 and startDay != 0)
		if days < 0 then 0 else days
	comingUpThisWeek: ->
		today = new Date()
		nextWeek = today.setDate(today.getDate()+7)
		# console.log nextWeek
		nextWeek > @startDate.date
	overlaps: (other) ->
		#console.log "this: #{@}"
		#console.log "other: #{other}"
		unless other is undefined
			overlap = (@startDate.date >= other.startDate.date and @startDate.date <= other.endDate.date) or (@endDate.date >= other.startDate.date and @endDate.date <= other.endDate.date) or (other.startDate.date >= @startDate.date and other.startDate.date <= @endDate.date) or (other.endDate.date >= @startDate.date and other.endDate.date <= @endDate.date)
			#console.log overlap
			overlap
	overlappingPeriod: (other) ->
		#console.log "this: #{@}"
		#console.log "other: #{other}"
		unless other is undefined or not @overlaps(other)
			if (@startDate.date > other.startDate.date) 
					startDate = @startDate.date
			else
				startDate = other.startDate.date 	
			if (@endDate.date < other.endDate.date)
					endDate = @endDate.date
			else 
				endDate = other.endDate.date
				
			new Period(startDate, endDate, "overlapping period")
	weeks: ->
		startWeek = getWeek(@startDate.date)
		endWeek = getWeek(@endDate.date)
		yrstring = @startDate.date.getFullYear().toString()
		wks = []
		for wk in [startWeek..endWeek]
			wks.push new Week(yrstring + wk.toString())
		#console.log wks
		wks
	@create: (jsonData) ->
		new Period(DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.Id)

class Milestone extends Mixin
	constructor: (@id, date, @time, @title, @description, @phaseId) ->
		@date = new DatePlus(date)
		@deliverables = []
	addDeliverable: (deliverable) ->
		@deliverables.push(deliverable)
	@create: (jsonData, phaseId) ->
		ms = new Milestone(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.Date), jsonData.Time, jsonData.Title, jsonData.Description, phaseId)
		for deliverable in jsonData.Deliverables
			ms.addDeliverable Deliverable.create(deliverable, ms)
		ms
	@createCollection: (jsonData) ->
		milestones = []
		for ms in jsonData
			@ms = Milestone.create(ms)
			milestones.push @ms
		milestones

class Phase extends Period
	# attach seperate startDate, endDate and title properties to each instance
	constructor: (@id, @startDate, @endDate, @title, @tfsIterationPath, @parentId) ->
		super @startDate, @endDate, @title
	@create: (jsonData, parentId) ->
		new Phase(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath, parentId)
	@createCollection: (jsonData) ->
		phases = []
		for phase in jsonData
			@phase = Phase.create(phase)
			phases.push @phase
		phases

class Week
	# format weekNr: YYYYww, e.g. 201248 (week 48 in 2012)
	constructor: (@weekNr) ->
	period: ->
		year=parseInt(@weekNr.substring(0,4),10)
		week=parseInt(@weekNr.substring(4,6),10)
		# JavaScript weekdays: Sun=0..Sat=6
		jan10=new Date(year,0,10,12,0,0)
		jan4=new Date(year,0,4,12,0,0)
		wk1mon=new Date(jan4.getTime()-(jan10.getDay())*86400000)
		startdate=new Date(wk1mon.getTime()+(week-1)*604800000)
		enddate=new Date(startdate.getTime()+518400000)
		new Period(startdate, enddate, "week " + @weekNr)
	shortNumber: ->
		parseInt(@weekNr.substring(4,6),10)

class Release extends Phase
	constructor: (@id, @startDate, @endDate, @title, @tfsIterationPath, @parentId) ->
		# pass along all args to parent ctor by using 'super' instead of 'super()'
		super
		@phases = [] # ko.observableArray()
		#@backlog = []
		#@resources = []
		@projects = []
		@milestones = []
	addPhase: (phase) ->
		@phases.push(phase)
	#addFeature: (feature) ->
		#@backlog.push(feature)
	#addResource: (resource) ->
		# console.log resource.initials + "->" + resource.memberProject
		#@resources.push(resource)
	addProject: (project) ->
		@projects.push(project)
	addMilestone: (milestone) ->
		@milestones.push(milestone)
	@create: (jsonData) ->
		console.log "create Release"
		#console.log jsonData
		#console.log "jsonData.Projects"
		#console.log jsonData.Projects
		#console.log jsonData.Projects.length
		#console.log "#{jsonData.StartDate} #{jsonData.EndDate}"
		release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.TfsIterationPath, jsonData.ParentId)
		for phase in jsonData.Phases
			release.addPhase Phase.create(phase, jsonData.Id)
		# for feat in jsonData.Backlog
			# console.log feat
			# release.addFeature Feature.create(feat)
		for project in jsonData.Projects
			release.addProject Project.create(project)
		for milestone in jsonData.Milestones
			release.addMilestone Milestone.create(milestone, jsonData.Id)
		#console.log release
		release
	@createCollection: (jsonDdata) ->
		releases = []
		# fill release collection
		for release in jsonDdata
			rel = Release.create release
			releases.push rel
		releases

# Release - Projects - Features & AssignedResources
class Project extends Mixin
	constructor: (@id, @title, @shortName, @descr, @tfsIterationPath, @tfsDevBranch, @release) ->
		@resources = []
		@backlog = []
		@workload = []
	@create: (jsonData, release) ->
		#console.log "create project - jsonData"
		#console.log jsonData
		project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch, release)
		# console.log project
		for res in jsonData.AssignedResources
			project.resources.push AssignedResource.create(res, project, release)
		for feature in jsonData.Backlog
			project.backlog.push Feature.create(feature, project)
		for act in jsonData.Workload
			project.workload.push ProjectActivityStatus.create(act, project)
		#console.log "created Project entity"
		#console.log project
		project
	@createCollection: (jsonData, release) ->
		#console.log "Project.createCollection"
		projects = []
		for project in jsonData
			@project = Project.create(project, release)
			projects.push @project
		projects

class AssignedResource extends Mixin
	constructor: (@id, @release, @resource, @project, @focusFactor, startDate, endDate, @activity, @milestone, @deliverable) ->
		#@resource = new Resource(resourceId, firstName, middleName, lastName)
		#@project = new Project(projectId, projectTitle)
		#@phase = new Phase(phaseId, "", "", phaseTitle)
		@assignedPeriod = new Period(startDate, endDate, "")
		# console.log "create AssignedResource:" + ko.toJSON(@assignedPeriod)
	@create: (jsonData, project, release) ->
		#console.log "create AssignedResource:" + ko.toJSON(jsonData)
		# create resource from json
		resource = Resource.create jsonData.Resource
		milestone = Milestone.create jsonData.Milestone
		deliverable = Deliverable.create jsonData.Deliverable
		activity = Activity.create jsonData.Activity
		# create under given project and release
		ass = new AssignedResource(jsonData.Id, release, resource, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), activity, milestone, deliverable)
		#console.log ass
		ass
	@createCollection: (jsonData, project, release) ->
		assignments = []
		for assignment in jsonData
			#console.log assignment
			@assignment = AssignedResource.create(assignment, project, release)
			assignments.push @assignment
		assignments
	availableHours: ->
		#console.log "assigned period #{@assignedPeriod}"
		#console.log "resource #{@resource.initials}"
		hoursPresent = @resource.hoursAvailable @assignedPeriod
		#console.log "hours present #{hoursPresent}"
		available = Math.round(hoursPresent * @focusFactor)
		#console.log "hours available corrected with assignment focus factor #{@focusFactor}: #{available}"
		available

class Feature
	constructor: (@businessId, @contactPerson, @estimatedHours, @hoursWorked, @priority, @project, @remainingHours, @title, @state) ->
	@create: (jsonData, project) ->
		#console.log "create feature"
		# create under given project
		feature = new Feature(jsonData.BusinessId, jsonData.ContactPerson, jsonData.EstimatedHours, jsonData.HoursWorked, jsonData.Priority, project, jsonData.RemainingHours, jsonData.Title, jsonData.Status)
		feature

class Deliverable extends Mixin
	constructor: (@id, @title, @description, @format, @location, @milestone) ->
		@activities = []
		@scope = []
	@create: (jsonData, milestone) ->
		#console.log "create Deliverable"
		deliverable = new Deliverable(jsonData.Id, jsonData.Title, jsonData.Description, jsonData.Format, jsonData.Location, milestone)
		for act in jsonData.ConfiguredActivities
			deliverable.activities.push Activity.create(act)
		for project in jsonData.Scope
			deliverable.scope.push Project.create(project)
		deliverable
	@createCollection: (jsonData) ->
		deliverables = []
		for del in jsonData
			@del = Deliverable.create(del)
			deliverables.push @del
		deliverables

class ProjectActivityStatus extends Mixin
	constructor: (@hoursRemaining, @activity) ->
		@assignedResources = []
	@create: (jsonData, project) ->
		#console.log "create ProjectActivityStatus"
		#console.log jsonData
		#proj = Project.create(jsonData.Project)
		act = Activity.create(jsonData.Activity)
		status = new ProjectActivityStatus(jsonData.HoursRemaining, act)
		for res in jsonData.AssignedResources
			status.assignedResources.push AssignedResource.create(res, project)
		status

class Activity extends Mixin
	constructor: (@id, @title, @description) ->
	@create: (jsonData) ->
		new Activity(jsonData.Id, jsonData.Title, jsonData.Description)
	@createCollection: (jsonData) ->
		activities = []
		for act in jsonData
			@act = Activity.create(act)
			activities.push @act
		activities

class Resource extends Mixin
	constructor: (@id, @firstName, @middleName, @lastName, @initials, @hoursPerWeek, @email, @phoneNumber, @company, @function) ->
		@periodsAway = []
		@assignments = []
	addAbsence: (period) ->
		@periodsAway.push(period)
	addAssignment: (per, rel, act) ->
		@assignments.push({period: per, release: rel, activity: act})
	fullName: ->
		middle = " " if (@middleName.length is 0)
		middle = " " + @middleName + " " if (@middleName.length > 0)
		@firstName + middle + @lastName
	isPresent: (date) ->
		away = absence for absence in @periodsAway when absence.containsDate(date)
		away.length is 0
	hoursAvailable: (period) ->
		# somehow "reduce (x,y)" needs a space between name ('reduce') and args
		# console.log period.toString()
		absent = 0
		# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
		overlappingAbsences = (absence for absence in @periodsAway when absence.overlaps(period))
		#if(typeof(overlappingAbsences) isnt 'undefined')
		#	console.log "overlappingAbsences: " + overlappingAbsences
		#	console.log "overlappingAbsences.length: " + overlappingAbsences.length
		if(overlappingAbsences? and typeof(overlappingAbsences) isnt 'undefined' and overlappingAbsences.length > 0)
			#away = 
			#absent = (absence.overlappingPeriod(period).workingDaysRemaining() for absence in overlappingAbsences).reduce (init, x) -> console.log x; init + x
			absent = (absence.overlappingPeriod(period) for absence in overlappingAbsences).reduce (acc, x) ->
					#console.log x
					result = if x.containsDate(new Date()) then x.workingDaysRemaining() else x.workingDays()
					acc + result
				, 0

			#console.log "overlappingAbsences more than 0"
		#console.log "absent days: " + absent
		# console.log "period working days remaining: " + period.workingDaysRemaining()
		amtDays = 0
		if period.containsDate(new Date())
			amtDays = period.workingDaysRemaining() - absent
		else
			amtDays = period.workingDays() - absent
		available = amtDays * 8
		# console.log "available hours: " + available
		available
	# @ to create a static method, attach to class object itself
	@create: (jsonData) ->
		#console.log "create Resource"
		res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber)
		for absence in jsonData.PeriodsAway
			# console.log "jsonData absence: " + absence
			res.addAbsence(new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Id))
		for assignment in jsonData.Assignments
			res.addAssignment(new Period(DateFormatter.createJsDateFromJson(assignment.StartDate), DateFormatter.createJsDateFromJson(assignment.EndDate), assignment.Activity.Title + " " + assignment.Phase.Title + " (" + assignment.FocusFactor + ")"), assignment.Phase.Title, assignment.Activity)
		#console.log res
		res
	@createCollection: (jsonData) ->
		#console.log jsonData
		resources = []
		for resource in jsonData
			@resource = Resource.create(resource)
			resources.push @resource
		resources
	toString: ->
		@fullName()


# datastructure for submitting all assignments with release
class ReleaseAssignments extends Mixin
	constructor: (@phaseId, @projectId, @assignments) ->

# export to root object
root.Period = Period
root.Week = Week
root.Phase = Phase
root.Milestone = Milestone
root.Release = Release
root.Feature = Feature
root.Resource = Resource
root.Project = Project
root.Deliverable = Deliverable
root.Activity = Activity
root.AssignedResource = AssignedResource
root.ProjectActivityStatus = ProjectActivityStatus
root.ReleaseAssignments = ReleaseAssignments

