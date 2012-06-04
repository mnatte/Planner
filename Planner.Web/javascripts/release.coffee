# access (for browser)
root = global ? window

	# '@' is shortcut for 'this'. Unlike C#, 'this' refers to 'this context', which can be different every time a function is called
	
	# 'new' says: don't return result of function, just create new object and run function in object's context
	# all properties are part of the prototype, except the constructor

	# Phase is an object; it is actually the constructor function
	# '@' insists that the property is attached to the class object itself

	# functions attached to the prototype are invoked in the context of the individual object
	# @-variables within those functions refer to the instance properties because the '@' context IS the object instance: e.g. phase.workingHours()

class Period extends Mixin
	# attach seperate startDate, endDate and title properties to each instance
	constructor: (startDate, endDate, @title) ->
		# console.log "title: #{@title}"
		# console.log "startDate: #{startDate}"
		# console.log "endDate: #{endDate}"
		@startDate = new DatePlus(startDate)
		@endDate = new DatePlus(endDate)
	# FOR MAKING title OBSERVABLE IN PARENT VIEWMODELS USE:
	# constructor: (startDate, endDate, title) ->
		# @title = ko.observable(title)
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
	isCurrent: ->
		today = new Date()
		today >= @startDate.date and today < @endDate.date
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
		days
	comingUpThisWeek: ->
		today = new Date()
		nextWeek = today.setDate(today.getDate()+7)
		# console.log nextWeek
		nextWeek > @startDate.date
	overlaps: (other) ->
		# console.log "other: #{other}"
		unless other is undefined
			# console.log (@startDate >= other.startDate and @startDate < other.endDate) or (@endDate >= other.startDate and @endDate < other.endDate)
			(@startDate.date >= other.startDate.date and @startDate.date < other.endDate.date) or (@endDate.date >= other.startDate.date and @endDate.date < other.endDate.date)
	toJSON: ->
		copy = ko.toJS(@) #get a clean copy
		delete copy.startDate.date #remove property
		copy.startDate = @startDate.dateString
		copy.endDate = @endDate.dateString
		copy #return the copy to be serialized

class Phase extends Period
	# attach seperate startDate, endDate and title properties to each instance
	constructor: (@id, @startDate, @endDate, @title, @tfsIterationPath, @parentId) ->
		super @startDate, @endDate, @title

class MileStone
	constructor: (@date, @title) ->

class Release extends Phase
	constructor: (@id, @startDate, @endDate, @title, @tfsIterationPath, @parentId) ->
		# pass along all args to parent ctor by using 'super' instead of 'super()'
		super
		@phases = [] # ko.observableArray()
		@backlog = []
		@resources = []
		@projects = []
	addPhase: (phase) ->
		@phases.push(phase)
	addFeature: (feature) ->
		@backlog.push(feature)
	addResource: (resource) ->
		# console.log resource.initials + "->" + resource.memberProject
		@resources.push(resource)
	addProject: (project) ->
		@projects.push(project)

class Feature
	constructor: (@businessId, @contactPerson, @estimatedHours, @hoursWorked, @priority, @project, @remainingHours, @title, @state) ->
	
class Resource extends Mixin
	constructor: (@id, @firstName, @middleName, @lastName, @initials, @hoursPerWeek, @email, @phoneNumber, @company, @function) ->
		@periodsAway = []
	addAbsence: (period) ->
		@periodsAway.push(period)
	fullName: ->
		middle = " " if (@middleName.length is 0)
		middle = " " + @middleName + " " if (@middleName.length > 0)
		@firstName + middle + @lastName
	# @ to create a static method, attach to class object itself
	@create: (jsonData) ->
		new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber)
	@createCollection: (jsonData) ->
		resources = []
		for resource in jsonData
			@resource = Resource.create(resource)
			resources.push @resource
		resources

class Project extends Mixin
	constructor: (@id, @title, @shortName, @descr, @tfsIterationPath, @tfsDevBranch) ->
	@create: (jsonData) ->
		new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch)
	@createCollection: (jsonData) ->
		projects = []
		for project in jsonData
			@project = Project.create project
			projects.push @project
		projects

class AssignedResource extends Mixin
	constructor: (@id, phaseId, phaseTitle, resourceId, firstName, middleName, lastName, projectId, projectTitle, @focusFactor) ->
		@resource = new Resource(resourceId, firstName, middleName, lastName)
		@project = new Project(projectId, projectTitle)
		@phase = new Phase(phaseId, "", "", phaseTitle)
	@create: (jsonData) ->
		new AssignedResource(jsonData.Id, jsonData.Phase.Id, jsonData.Phase.Title, jsonData.Resource.Id, jsonData.Resource.FirstName, jsonData.Resource.MiddleName, jsonData.Resource.LastName, jsonData.Project.Id, jsonData.Project.Title, jsonData.FocusFactor)
	@createCollection: (jsonData) ->
		assignments = []
		for assignment in jsonData
			#console.log assignment
			@assignment = AssignedResource.create assignment
			assignments.push @assignment
		assignments
	
# export to root object
root.Period = Period
root.Phase = Phase
root.MileStone = MileStone
root.Release = Release
root.Feature = Feature
root.Resource = Resource
root.Project = Project
root.AssignedResource = AssignedResource

