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
		if days < 0 then 0 else days
	workingHours: ->
		@workingDays() * 8
	toString: ->
		"#{@title} #{@startDate.dateString} - #{@endDate.dateString} (#{@workingDays()} working days) [#{@remainingWorkingDays()} remaining working days]"
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
	workingDaysFromNow: ->
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
	remainingWorkingDays: ->
		amtDays = 0
		if @containsDate(new Date())
			amtDays = @workingDaysFromNow()
		else if new Date() < @endDate.date
			amtDays = @workingDays()
		#if amtDays < 0 then 0 else amtDays
		amtDays
	remainingWorkingHours: ->
		@remainingWorkingDays() * 8
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
		#console.log 'create Milestone'
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
	constructor: (@id, @startDate, @endDate, @title, @parentId) ->
		super @startDate, @endDate, @title, @id
	@create: (jsonData, parentId) ->
		new Phase(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, parentId)
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
	constructor: (@id, @startDate, @endDate, @title, @parentId) ->
		# pass along all args to parent ctor by using 'super' instead of 'super()'
		super
		@phases = [] # ko.observableArray()
		#@backlog = []
		#@resources = []
		@projects = []
		@milestones = []
		@meetings = []
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
	addMeeting: (meeting) ->
		@meetings.push(meeting)
	@create: (jsonData) ->
		#console.log "create Release"
		#console.log jsonData
		#console.log "jsonData.Projects"
		#console.log jsonData.Projects
		#console.log jsonData.Projects.length
		#console.log "#{jsonData.StartDate} #{jsonData.EndDate}"
		release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.ParentId)
		if jsonData.Phases != null and jsonData.Phases  != undefined
			for phase in jsonData.Phases
				release.addPhase Phase.create(phase, jsonData.Id)
		# for feat in jsonData.Backlog
			# console.log feat
			# release.addFeature Feature.create(feat)
		if jsonData.Projects != null and jsonData.Projects  != undefined
			for project in jsonData.Projects
				release.addProject Project.create(project)
		if jsonData.Milestones != null and jsonData.Milestones  != undefined
			for milestone in jsonData.Milestones
				release.addMilestone Milestone.create(milestone, jsonData.Id)
		if jsonData.Meetings != null and jsonData.Meetings  != undefined
			for meeting in jsonData.Meetings
				release.addMeeting Meeting.create(meeting, jsonData.Id)
		#console.log release
		release
	@createSnapshot: (jsonData) ->
		release = new Release(jsonData.Id, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), jsonData.Title, jsonData.ParentId)
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
	constructor: (@id, @title, @shortName, @descr, @release) ->
		@resources = []
		@backlog = []
		@workload = []
	@create: (jsonData, release) ->
		#console.log "create project - jsonData"
		#console.log jsonData
		project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, release)
		# console.log project
		for res in jsonData.AssignedResources
			project.resources.push Assignment.create(res, null, project, release)
		for feature in jsonData.Backlog
			project.backlog.push Feature.create(feature, project)
		for act in jsonData.Workload
			project.workload.push ProjectActivityStatus.create(act, project)
		#console.log "created Project entity"
		#console.log project
		project
	@createSnapshot: (jsonData) ->
		project = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description)
		project
	@createCollection: (jsonData, release) ->
		#console.log "Project.createCollection"
		projects = []
		for project in jsonData
			@project = Project.create(project, release)
			projects.push @project
		projects

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
		for json in jsonData.AssignedResources
			status.assignedResources.push Assignment.create(json, null, project, null)
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

# Release - Meetings (- Roles?)
class Meeting extends Mixin
	constructor: (@id, @title, @objective, @descr, @moment, @date, @time, @releaseId) ->
	@create: (jsonData) ->
		meeting = new Meeting(jsonData.Id, jsonData.Title, jsonData.Objective, jsonData.Description, jsonData.Moment, jsonData.Date, jsonData.Time)
		meeting
	@createCollection: (jsonData) ->
		meetings = []
		for meeting in jsonData
			@meeting = Meeting.create(meeting)
			meetings.push @meeting
		meetings

class Resource extends Mixin
	constructor: (@id, @firstName, @middleName, @lastName, @initials, @hoursPerWeek, @email, @phoneNumber, @company, @function) ->
		@periodsAway = []
		@assignments = []
	addAbsence: (period) ->
		@periodsAway.push(period)
	addAssignment: (assignment) ->
		@assignments.push(assignment)
	fullName: ->
		middle = " " if (@middleName.length is 0)
		middle = " " + @middleName + " " if (@middleName.length > 0)
		@firstName + middle + @lastName
	isPresent: (date) ->
		away = absence for absence in @periodsAway when absence.containsDate(date)
		away.length is 0
	# @ to create a static method, attach to class object itself
	@create: (jsonData) ->
		#console.log "create Resource"
		#console.log jsonData
		res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber)
		for absence in jsonData.PeriodsAway
			# console.log "jsonData absence: " + absence
			res.addAbsence(new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title, absence.Id))
		for assignment in jsonData.Assignments
			res.addAssignment(Assignment.create(assignment, Resource.createSnapshot jsonData))
		#console.log res
		res
	@createSnapshot: (jsonData) ->
		#console.log "create Resource"
		#console.log jsonData
		res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials)
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

class Assignment extends Mixin
	constructor: (@id, @release, @resource, @project, @focusFactor, startDate, endDate, @activity, @milestone, @deliverable) ->
		@period = new Period(startDate, endDate, @deliverable.title + ' ' + @activity.title + ' ' + @release.title + ' (' + @focusFactor + ') ' + @project.title)
	@create: (jsonData, resource, project, release) ->
		#console.log "create Assignment:" + ko.toJSON(jsonData)
		# use when given else create from json data
		if(typeof(resource) is "undefined" or resource is null)
			resource = Resource.create jsonData.Resource
		if(typeof(release) is "undefined" or release is null)
			release = Release.createSnapshot jsonData.Phase
		if(typeof(project) is "undefined" or project is null)
			project = Project.createSnapshot jsonData.Project

		milestone = Milestone.create jsonData.Milestone
		deliverable = Deliverable.create jsonData.Deliverable
		activity = Activity.create jsonData.Activity
		
		ass = new Assignment(jsonData.Id, release, resource, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), activity, milestone, deliverable)
		#console.log ass
		ass
	@createCollection: (jsonData, resource, project, release) ->
		assignments = []
		for assignment in jsonData
			#console.log assignment
			@assignment = Assignment.create(assignment, resource, project, release)
			assignments.push @assignment
		assignments
	resourceAvailableHours: ->
		hoursPresent = @resource.hoursAvailable @period
		available = Math.round(hoursPresent * @focusFactor)
		available

#class ResourceAssignment extends Mixin
#	constructor: (@id, @release, @resource, @project, @focusFactor, startDate, endDate, @activity, @milestone, @deliverable) ->
#		@period = new Period(startDate, endDate, @deliverable.title + ' ' + @activity.title + ' ' + @release.title + ' (' + @focusFactor + ') ' + @project.title)
#	@create: (jsonData, resource) ->
#		#console.log "create ResourceAssignment:" + ko.toJSON(jsonData)
#		milestone = Milestone.create jsonData.Milestone
#		deliverable = Deliverable.create jsonData.Deliverable
#		activity = Activity.create jsonData.Activity
#		release = Release.createSnapshot jsonData.Phase
#		project = Project.createSnapshot jsonData.Project
#		# create under given project and release
#		ass = new ResourceAssignment(jsonData.Id, release, resource, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), activity, milestone, deliverable)
#		#console.log ass
#		ass
#	@createCollection: (jsonData, resource) ->
#		assignments = []
#		for assignment in jsonData
#			#console.log assignment
#			@assignment = ResourceAssignment.create(assignment, resource)
#			assignments.push @assignment
#		assignments

#class AssignedResource extends Mixin
#	constructor: (@id, @release, @resource, @project, @focusFactor, startDate, endDate, @activity, @milestone, @deliverable) ->
#		@assignedPeriod = new Period(startDate, endDate, "")
#	@create: (jsonData, project, release) ->
#		resource = Resource.create jsonData.Resource
#		milestone = Milestone.create jsonData.Milestone
#		deliverable = Deliverable.create jsonData.Deliverable
#		activity = Activity.create jsonData.Activity
		# create under given project and release
#		ass = new AssignedResource(jsonData.Id, release, resource, project, jsonData.FocusFactor, DateFormatter.createJsDateFromJson(jsonData.StartDate), DateFormatter.createJsDateFromJson(jsonData.EndDate), activity, milestone, deliverable)
		#console.log ass
#		ass
#	@createCollection: (jsonData, project, release) ->
#		assignments = []
#		for assignment in jsonData
			#console.log assignment
#			@assignment = AssignedResource.create(assignment, project, release)
#			assignments.push @assignment
#		assignments
#	availableHours: ->
		#console.log "assigned period #{@assignedPeriod}"
		#console.log "resource #{@resource.initials}"
#		hoursPresent = @resource.hoursAvailable @assignedPeriod
		#console.log "hours present #{hoursPresent}"
#		available = Math.round(hoursPresent * @focusFactor)
		#console.log "hours available corrected with assignment focus factor #{@focusFactor}: #{available}"
#		available

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
root.Meeting = Meeting
root.Deliverable = Deliverable
root.Activity = Activity
root.Assignment = Assignment
#root.AssignedResource = AssignedResource
#root.ResourceAssignment = ResourceAssignment
root.ProjectActivityStatus = ProjectActivityStatus
root.ReleaseAssignments = ReleaseAssignments

