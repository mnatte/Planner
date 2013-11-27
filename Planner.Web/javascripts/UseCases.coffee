#require release.js
#require releaseViewmodel.js
#require knockout 2.0.0.js

# access (for browser)
root = global ? window

class UDisplayReleaseStatus
	constructor: ->
		Release.extend(RGroupBy)
		Resource.extend(RTeamMember)
	# use AJAX data in executing use case
	execute: (data) ->
		@release = Release.create data
		# set HTML page title
		document.title = data.Title
		
		# create aggregation of all feature states through RGroupBy role
		releaseBacklog = []
		for proj in @release.projects
			releaseBacklog = releaseBacklog.concat proj.backlog
		@release.group 'state', releaseBacklog

		@viewModel = new ReleaseViewmodel(@release)
		ko.applyBindings(@viewModel)
		@viewModel.selectedPhaseId @viewModel.release.phases[0].id
		# show charts
		showStatusChart(@viewModel.statusData())

class UCalculateNeededResources
	constructor: (@deliverable, @period, @focusFactor, @viewModel) ->
	execute: (data) ->
		@viewModel = new CalculateNeededResourcesViewmodel(@deliverable, @period, @focusFactor)
		ko.applyBindings(@viewModel)
		
class UGetAvailableHoursForTeamMemberFromNow
	constructor: (@teamMember, @phase) ->
	execute: ->
		today = new Date()
		if (today > @phase.endDate.date)
			0
		else
			#console.log @teamMember
			# console.log "available hours for: #{@teamMember.initials}"
			# console.log "in phase: #{@phase.toString()}"
			# set start date of phase to Now when startdate of phase is already passed
			if today > @phase.startDate.date and today > member.
				startDate = today
			else
				startDate = @phase.startDate.date
			restPeriod = new Period(startDate, @phase.endDate.date, @phase.title)
			# console.log "period from now: #{restPeriod}"
			#console.log "periods away: #{@teamMember.periodsAway}"
			absentHours = 0
			for absence in @teamMember.periodsAway when (absence.overlaps @phase)
				#console.log "absence overlaps phase"
				#console.log absence
				periodAway = absence.overlappingPeriod(@phase)
				#console.log "periodAway: #{periodAway.toString()}"
				# days away between today or startdate of phase
				if today > absence.startDate.date
					start = today
				else
					start = absence.startDate.date
				remainingAbsence = new Period(start, periodAway.endDate.date, 'remaining absence from now')
				absentHours += remainingAbsence.workingHours()
			#console.log "absentHours: #{absentHours}"
			availableHours = restPeriod.workingHours() - absentHours
			# console.log "availableHours: #{availableHours}"
			# console.log "corrected with focusfactor #{@teamMember.focusFactor}: #{@teamMember.focusFactor * availableHours}"
			@teamMember.focusFactor * availableHours

class UDisplayPhases
	constructor: ->
	execute: (data) ->
		releases = Release.createCollection(data)
		#console.log releases
		@viewModel = new PhasesViewmodel(releases)
		@viewModel.load releases.sort((a,b)->a.startDate.date - b.startDate.date)
		ko.applyBindings(@viewModel)
		timeline = new Mnd.Timeline(@viewModel.showPhases, @viewModel.selectedTimelineItem, "100%", "1200px")
		timeline.draw()

class UDisplayEnvironments
	constructor: ->
	execute: (envsJson, versionsJson) ->
		environments = Environment.createCollection(envsJson)
		versions = Version.createCollection(versionsJson)
		@viewModel = new EnvironmentsPlanningViewmodel(environments, versions)
		ko.applyBindings(@viewModel)

		uc = new UDisplayEnvironmentsGraph(environments, @viewModel.selectedTimelineItem)
		uc.execute()
		#timeline = new Mnd.Timeline(@displayData, @viewModel.selectedTimelineItem)
		#timeline.draw()

class UDisplayEnvironmentsGraph
	constructor: (@environments, @selectedTimelineItem) ->
	execute: ->
		@displayData = []
		for env in @environments 
			for pl in env.planning
				pl.environmentId = env.id
				obj = {group: env.name, start: pl.phase.startDate.date, end: pl.phase.endDate.date, content: pl.version.number, info: pl.phase.toString(), dataObject: pl}
				@displayData.push obj
			#for ms in env.planning.milestones
			#	icon = '<span class="icon icon-milestone" />'
			#	descr = '<ul>' # deployments
			#	descr += '<li>' # deployment
			#	descr += '</li>' # /deployment
			#	descr += '</ul>' # /deployments
			#	obj = {group: rel.title, start: ms.date.date, content: ms.title + '<br />' + icon, info: ms.date.dateString + '<br />' + ms.description, dataObject: ms}
			#	@displayData.push obj
		timeline = new Mnd.Timeline(@displayData, @selectedTimelineItem)
		timeline.draw()
		

class UAjax
	constructor: (@callBack) ->
	execute: ->
		throw new Error('Abstract method execute of UAjax UseCase')
	refreshData: (json) ->
		console.log json
		@callBack json

class UCreateVisualCuesForGates extends UAjax
	constructor: (@amountDays, @callBack) ->
		super @callBack
	execute: ->
		ajx = new Ajax()
		ajx.createCuesForGates @amountDays, (json) => @refreshData(json)

class UCreateVisualCuesForAbsences extends UAjax
	constructor: (@amountDays, @callBack) ->
		super @callBack
	execute: ->
		ajx = new Ajax()
		ajx.createCuesForAbsences @amountDays, (json) => @refreshData(json)

class UDisplayAbsences
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection(data)
		#console.log releases
		@viewModel = new AbsencesViewmodel(resources)
		@viewModel.load resources.sort()
		ko.applyBindings(@viewModel)
		timeline = new Mnd.Timeline(@viewModel.showAbsences, @viewModel.selectedTimelineItem, "100%", "1000px",)
		timeline.draw()

class UDisplayAssignments
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection(data)
		@viewModel = new AssignmentsViewmodel(resources)
		@viewModel.load resources.sort()
		ko.applyBindings(@viewModel)
		timeline = new Mnd.Timeline(@viewModel.showAssignments, @viewModel.selectedTimelineItem)
		timeline.draw()

class UReloadAbsenceInTimeline
	constructor: (@allAbsences, @index, @refreshedTimelineItem) ->
	execute: ->
		timeline = new Mnd.Timeline(allAbsences, refreshedTimelineItem)
		timeline.draw()

class ULoadAdminReleases
	constructor: ->
	execute: (jsonRels, jsonProjects, jsonDeliverables) ->
		releases = Release.createCollection(jsonRels)
		projects = Project.createCollection jsonProjects
		deliverables = Deliverable.createCollection jsonDeliverables
		@viewModel = new AdminReleaseViewmodel(releases, projects, deliverables)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		ko.applyBindings(@viewModel, null, {independentBindings: true})

class ULoadUpdateReleaseStatus
	constructor: ->
	execute: (jsonRels) ->
		releases = Release.createCollection(jsonRels)
		@viewModel = new UpdateReleaseStatusViewmodel(releases)
		@viewModel.selectRelease @viewModel.allReleases[0]
		ko.applyBindings(@viewModel, null, {independentBindings: true})

class ULoadAdminProjects
	constructor: ->
	execute: (data) ->
		projects = Project.createCollection data
		@viewModel = new AdminProjectViewmodel(projects)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminEnvironments
	constructor: ->
	execute: (data) ->
		items = Environment.createCollection data
		@viewModel = new AdminEnvironmentViewmodel(items)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminMeetings
	constructor: ->
	execute: (data) ->
		items = Meeting.createCollection data
		@viewModel = new AdminMeetingViewmodel(items)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class UDisplayPlanningOverview
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection data
		@viewModel = new PlanningOverviewViewmodel(resources)
		ko.applyBindings(@viewModel)

class UDisplayResourcesAvailability
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection data
		@viewModel = new ResourceAvailabilityViewmodel(resources)
		ko.applyBindings(@viewModel)

class ULoadAdminResources
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection data
		@viewModel = new AdminResourceViewmodel(resources)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminDeliverables
	constructor: ->
	execute: (acts, data) ->
		deliverables = Deliverable.createCollection data
		activities = Activity.createCollection acts
		@viewModel = new AdminDeliverableViewmodel(deliverables, activities)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminActivities
	constructor: ->
	execute: (data) ->
		items = Activity.createCollection data
		@viewModel = new AdminActivityViewmodel(items)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminProcesses
	constructor: ->
	execute: (data) ->
		items = Process.createCollection data
		@viewModel = new AdminProcessViewmodel(items)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadPlanResources
	constructor: ->
	execute: (releases, resources, activities) ->
	#execute: (releases) ->
		releases = Release.createCollection(releases)
		console.log releases
		resources = Resource.createCollection resources
		activities = Activity.createCollection activities
		# console.log resources
		@viewModel = new PlanResourcesViewmodel(releases, resources, activities)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		ko.applyBindings(@viewModel)

# show Release planning

class UDisplayReleaseOverview
	constructor: ->
	execute: (rels, resources, activities) ->
		releases = Release.createCollection(rels)
		allResources = Resource.createCollection(resources)
		allActivities = Activity.createCollection(activities)
		#console.log releases
		#console.log allResources
		@viewModel = new ReleaseOverviewViewmodel(releases, allResources, allActivities)
		ko.applyBindings(@viewModel)

class UDisplayPlanningForResource
	constructor: (@resource, @period) ->
	execute: ->
		displayData = []
		console.log @resource.fullName()
		i = 0
		for absence in (abs for abs in @resource.periodsAway when abs.overlaps(@period)) # resource.periodsAway
			dto = absence
			dto.person = @resource
			obj = {group: @resource.fullName() + '[' + i + ']', start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: dto}
			displayData.push obj
			i++
		for assignment in (ass for ass in @resource.assignments when ass.period.overlaps(@period)) #resource.assignments
			dto = assignment
			dto.person = @resource
			obj = {group: @resource.fullName() + '[' + i + ']', start: assignment.period.startDate.date, end: assignment.period.endDate.date, content: assignment.period.title, info: assignment.period.toString(), dataObject: dto}
			displayData.push obj
			i++
		showAssignments = displayData.sort((a,b)-> a.start - b.end)
		timeline = new Mnd.Timeline(showAssignments, null, "100%", "200px", "resourceTimeline", "resourceDetails")
		timeline.draw()

class UDisplayPlanningForMultipleResources
	constructor: (@resources, @period) ->
	execute: ->
		displayData = []
		for resource in @resources
			console.log resource.fullName()
			i = 0
			for absence in (abs for abs in resource.periodsAway when abs.overlaps(@period)) # resource.periodsAway
				dto = absence
				dto.person = resource
				obj = {group: resource.fullName() + '[' + i + ']', start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: dto}
				displayData.push obj
				i++
			for assignment in (ass for ass in resource.assignments when ass.period.overlaps(@period)) #resource.assignments
				dto = assignment
				dto.person = resource
				obj = {group: resource.fullName() + '[' + i + ']', start: assignment.period.startDate.date, end: assignment.period.endDate.date, content: assignment.period.title, info: assignment.period.toString(), dataObject: dto}
				displayData.push obj
				i++
		showAssignments = displayData.sort((a,b)-> a.start - b.end)
		timeline = new Mnd.Timeline(showAssignments, null, "100%", "200px", "resourceTimeline", "resourceDetails")
		timeline.draw()

class URefreshView
	constructor: (@selectedObservable, @checkPeriod) ->
	execute: ->
		resWithAssAndAbsInDate = @selectedObservable()
		resWithAssAndAbsInDate.assignments = (a for a in @selectedObservable().assignments when a.period.overlaps(@checkPeriod))
		resWithAssAndAbsInDate.periodsAway = (a for a in @selectedObservable().periodsAway when a.overlaps(@checkPeriod))
		#console.log resWithAssAndAbsInDate
		@selectedObservable resWithAssAndAbsInDate

class URefreshViewAfterCheckPeriod
	constructor: (@checkPeriod, @viewModelObservableGraph, @viewModelObservableForm) ->
	execute: ->
		@viewModelObservableGraph null
		@viewModelObservableForm null

class UPersistAndRefresh
	# @selectedObservable is the observable to set to the refreshed item itself, used in callback to refresh the view on its properties
	# @updateViewUsecase is the callback usecase, @observableShowform is the observable used for hiding the form after processing
	# @dehydrate is the function used in the callback to instantiate the new item by the returned json data
	constructor: (@viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate) ->
	execute: ->
		throw new Error('Abstract method execute of UPersistAndRefresh UseCase')
	refreshData: (json) ->
		console.log json
		console.log @dehydrate
		if @dehydrate and @viewModelObservableCollection
			refreshed = @dehydrate json
			# replace old item in collection for new one
			oldItem = r for r in @viewModelObservableCollection() when r.id is refreshed.id
			#console.log oldItem
			index = @viewModelObservableCollection().indexOf(oldItem)
			@viewModelObservableCollection.splice index, 1, refreshed
		if @selectedObservable
			@selectedObservable refreshed
		if @observableShowform
			@observableShowform null
		# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
		if @updateViewUsecase
			@updateViewUsecase.execute()

class UPlanEnvironment extends UPersistAndRefresh
	constructor: (@environment, @version, @period, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		console.log @period
		Environment.extend RPlanEnvironment
		Environment.setPlanUrl "/planner/Environment/Plan"
		#version, startDateString, endDateString, purpose, callback
		@environment.plan(@version, @period, (data) => @refreshData(data))

class UUnAssignEnvironment extends UPersistAndRefresh
	constructor: (@environment, @version, @period, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		console.log @period
		Environment.extend RPlanEnvironment
		Environment.setUnAssignUrl "/planner/Environment/Plan/UnAssign"
		#version, startDateString, endDateString, purpose, callback
		@environment.unplan(@version, @period, (data) => @refreshData(data))


		

class URescheduleMilestone extends UPersistAndRefresh
	# @assignment contains the data to persist. @viewModelObservableCollection is the collection to replace the old item in
	constructor: (@milestone, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		Milestone.extend RScheduleItem
		Milestone.setScheduleUrl "/planner/Release/Milestone/Schedule"
		console.log 'execute URescheduleMilestone'
		@milestone.schedule(@milestone.id, @milestone.phaseId, @milestone.date.dateString, @milestone.time, (data) => @refreshData(data))

class UReschedulePhase extends UPersistAndRefresh
	# @assignment contains the data to persist. @viewModelObservableCollection is the collection to replace the old item in
	constructor: (@phase, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		Phase.extend RSchedulePeriod
		Phase.setScheduleUrl "/planner/Release/Phase/Schedule"
		console.log 'execute UReschedulePhase'
		@phase.schedule(@phase.id, @phase.parentId, @phase.startDate.dateString, @phase.endDate.dateString, (data) => @refreshData(data))

class UModifyAssignment extends UPersistAndRefresh
	# @assignment contains the data to persist. @viewModelObservableCollection is the collection to replace the old item in
	constructor: (@assignment, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @sourceView, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		console.log 'execute UModifyAssignment'
		console.log @assignment
		json = ko.toJSON(@assignment)
		console.log json
		console.log @sourceView
		if @sourceView is "release"
			# rel, proj, ms, del, act, per, ff
			@assignment.resource.planForRelease(@assignment.release, @assignment.project, @assignment.milestone, @assignment.deliverable, @assignment.activity, @assignment.period, @assignment.focusFactor, (data) => @refreshData(data))
		else if @sourceView is "resource"
			# rel, proj, ms, del, act, per, ff
			@assignment.resource.plan(@assignment.release, @assignment.project, @assignment.milestone, @assignment.deliverable, @assignment.activity, @assignment.period, @assignment.focusFactor, (data) => @refreshData(data))

class UAddAssignments extends UPersistAndRefresh
	# @assignment contains the data to persist. @viewModelObservableCollection is the collection to replace the old item in
	constructor: (@assignments, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @sourceView, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		console.log 'execute UAddAssignments'
		#console.log @assignments
		#json = ko.toJSON(@assignments)
		#console.log json
		#console.log @sourceView
		resourceIds = @assignments.resources.reduce (acc, x) =>
							acc.push x.id
						 acc
					, []
		dataObject = { phaseId: @assignments.release.id, projectId: @assignments.project.id, milestoneId: @assignments.milestone.id, deliverableId: @assignments.deliverable.id, activityId: @assignments.activity.id, startDate: @assignments.period.startDate.dateString, endDate: @assignments.period.endDate.dateString, focusFactor: @assignments.focusFactor, resourceIds: resourceIds }
		console.log dataObject
		@process(dataObject, (data) => @refreshData(data))
	process: (dataObject, callback) ->
		# submit data
		$.ajax "/planner/Resource/Release/PlanMultiple",
			dataType: "json"
			data: ko.toJSON(dataObject)
			type: "POST"
			contentType: "application/json; charset=utf-8"
			success: (data, status, XHR) ->
				console.log "planned resources processsed"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX SAVE error: #{errorThrown}"

class UDeleteAssignment extends UPersistAndRefresh
	constructor: (@assignment, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @sourceView, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		console.log 'execute UDeleteResourceAssignment'
		json = ko.toJSON(@assignment)
		console.log json
		if @sourceView is "release"
			# rel, proj, ms, del, act, per, ff
			@assignment.resource.unassignFromRelease(@assignment.release, @assignment.project, @assignment.milestone, @assignment.deliverable, @assignment.activity, @assignment.period, (data) => @refreshData(data))
		else if @sourceView is "resource"
			# rel, proj, ms, del, act, per, ff
			@assignment.resource.unassign(@assignment.release, @assignment.project, @assignment.milestone, @assignment.deliverable, @assignment.activity, @assignment.period, (data) => @refreshData(data))

class UUpdateDeliverableStatus extends UPersistAndRefresh
	constructor: (@selectedDeliverable, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @sourceView, @dehydrate) ->
		super @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform, @dehydrate
	execute: ->
		Deliverable.extend(RCrud)
		Deliverable.extend(RDeliverableSerialize)
		Project.extend(RProjectSerialize)
		ProjectActivityStatus.extend(RProjectActivityStatusSerialize)
		status = @selectedDeliverable.toStatusJSON()
		console.log ko.toJSON(status)
		@selectedDeliverable.save("/planner/Release/SaveDeliverableStatus", ko.toJSON(status), (data) => @refreshData(data))

class UUpdateScreen
	constructor: (@usecases, @delegates) ->
	execute: ->
		console.log @usecases
		console.log @delegates
		if @usecases
			for uc in @usecases
				uc.execute()
		if @delegates
			for del in @delegates
				del()
				true

class UDisplayReleaseTimeline
	# depends on timeline.js and having an HTML div with id 'mytimeline'
	constructor: (@observableRelease, @observableTimelineSource) ->
	execute: ->
		@displayData = []
		console.log 'execute use case UDisplayReleaseTimeline'
		for ph in @observableRelease().phases
			#cont = '<span style="background-color:pink" />' + ph.title + '</span>'
			cont = ph.title
			obj = {group: @observableRelease().title, start: ph.startDate.date, end: ph.endDate.date, content:  cont, info: ph.toString(), dataObject: ph }
			@displayData.push obj
		for ms in @observableRelease().milestones
			icon = '<span class="icon icon-milestone" />'
			style = 'style="color: green"'
			descr = '<ul>'
			for del in ms.deliverables
				#console.log del.title
				descr += '<li>' + del.title + '<ul>'
				for proj in del.scope
					descr += '<li>' + proj.title
					descr += '<ul>'
					activities = proj.workload.reduce (acc, x) ->
								acc.push {activityTitle: x.activity.title, hrs: x.hoursRemaining, planned: x.assignedResources.reduce ((acc, x) -> acc + x.resourceAvailableHours()), 0 }
								acc
							, []
					for act in activities
						if act.hrs > act.planned
							icon = '<span class="icon icon-warning" />'
							style = 'style="color: red"'
						else
							style = 'style="color: green"'
						descr += '<li ' + style + '>' + act.activityTitle + ': ' + act.hrs + ' hours remaining, ' + act.planned + ' remaining resource hours planned (incl. absences)</li>'
					descr += '</ul>' # /activities
					descr += '</li>' # /project
				descr += '</ul>' # /projects
			descr += '</li>' # /deliverable
			descr += '</ul>' # /deliverables
			ms.release = { id: @observableRelease().id, title: @observableRelease().title }
			obj = {group: @observableRelease().title, start: ms.date.date, content: ms.title + '<br />' + icon, info: ms.date.dateString + ' - ' + ms.time + '<br />' + descr, dataObject: ms}
			@displayData.push obj
		showData = @displayData.sort((a,b)-> a.start - b.end)
		console.log showData
		timeline = new Mnd.Timeline(showData, @observableTimelineSource, "100%", "200px", "releaseTimeline", "releaseDetails")
		timeline.draw()
		timeline.clearDetails()

class UDisplayReleasePlanningInTimeline
	# depends on timeline.js
	constructor: (@observableRelease, @observableTimelineItem, @resources) ->
	execute: ->
		@trackAssignments = []
		@displayData = []
		#@plannedResources = []
		@absencesDone = []
		releaseTitle = @observableRelease().title
		console.log 'execute use case UDisplayReleasePlanningInTimeline'
		console.log @observableRelease()
		#console.log @resources
		uniqueAsses = []
		# assignments
		for ms in @observableRelease().milestones
			console.log ms
			for del in ms.deliverables
				console.log del
				for proj in del.scope
					for activity in proj.workload
						for assignment in activity.assignedResources
							console.log assignment
							dto = assignment # trick for adding info: dto.person = resource
							resource = @createRowItem(assignment.resource.fullName(), 0)
							obj = {group: resource, start: assignment.period.startDate.date, end: assignment.period.endDate.date, content: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.project.title, info: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.period.toString()  + '(' + assignment.remainingAssignedHours() + ' hrs remaining)', dataObject: dto}
							@displayData.push obj
							# TODO: use for totals
							# @addToPlannedResources assignment.resource
							# absences
							if not @resourceAbsencesDone(assignment.resource)
								for absence in (abs for abs in assignment.resource.periodsAway when abs.overlaps(@observableRelease())) # resource.periodsAway
									console.log absence
									dto = absence
									dto.person = assignment.resource
									res = @createRowItem(assignment.resource.fullName(), 0)
									obj = {group: res, start: absence.startDate.date, end: absence.endDate.date, content: absence.title, info: absence.toString(), dataObject: dto}
									@displayData.push obj
		console.log @plannedResources
		showData = @displayData.sort((a,b)-> a.start - b.end)
		timeline = new Mnd.Timeline(showData, @observableTimelineItem, "100%", "800px", "resourcePlanning", "assignmentDetails")
		timeline.draw()
		timeline.clearDetails()
	createRowItem: (item, index) ->
		identifier = item + index
		if @trackAssignments.indexOf(identifier) is -1
			@trackAssignments.push(identifier)
			item + '[' + index + ']'
		else
			index++
			@createRowItem item, index
	# addToPlannedResources: (resource) ->
		#identifier = resource
		#if @plannedResources.indexOf(identifier) is -1
		#	@plannedResources.push resource
	resourceAbsencesDone: (resource) ->
		identifier = resource.id
		if @absencesDone.indexOf(identifier) is -1
			@absencesDone.push resource.id
			false
		else
			true

class UDisplayPlannedHoursPerActivityArtefactProject
	# depends on timeline.js
	constructor: (@observableRelease) ->
	execute: ->
		for ms in @observableRelease().milestones
			descr = '<ul>'
			for del in ms.deliverables
				#console.log del.title
				descr += '<li>' + del.title + '<ul>'
				for proj in del.scope
					descr += '<li>' + proj.title
					descr += '<ul>'
					activities = proj.workload.reduce (acc, x) ->
								acc.push {activityTitle :x.activity.title, hrs: x.hoursRemaining, planned: x.assignedResources.reduce ((acc, x) -> acc + x.resourceAvailableHours()), 0 }
								acc
							, []
					for act in activities
						if act.hrs > act.planned
							style = 'style="color: red"'
						else
							style = 'style="color: green"'
						descr += '<li ' + style + '>' + act.activityTitle + ': ' + act.hrs + ' hours remaining, ' + act.planned + ' hours planned (incl. absences)</li>'
					descr += '</ul>' # /activities
					descr += '</li>' # /project
				descr += '</ul>' # /projects
			descr += '</li>' # /deliverable
			descr += '</ul>' # /deliverables
			# todo: print 'descr' variable 

class UDisplayReleasePhases
	constructor: (@release, @viewModelObservableGraph) ->
	execute: ->
		#console.log releases
		@viewModel = new PhasesViewmodel(releases)
		@viewModel.load releases.sort((a,b)->a.startDate.date - b.startDate.date)
		ko.applyBindings(@viewModel)
		timeline = new Mnd.Timeline(@viewModel.showPhases)
		timeline.draw()
		#drawTimeline(@viewModel.showPhases)

class UDisplayReleaseProgressOverview
	constructor: ->
	execute: (data) ->
		releases = Release.createCollection(data)
		console.log releases
		@viewModel = new ReleaseProgressViewmodel(releases)
		ko.applyBindings(@viewModel)

class UDisplayBurndown
	constructor: (@title, @divName) ->
	execute: (data) ->
		#@viewModel = new ProcessPerformanceViewmodel()
		#ko.applyBindings(@viewModel)
		console.log @title
		#@viewModel.velocity data.Velocity
		$(@divName).html('')
		header = @title + ' - Velocity: ' + data.Velocity
		chart = new Mnd.NumericChart(@divName, 'Burndown Chart', header)
		i = 0
		for graph in data.Graphs
			#console.log graph
			#console.log graph.Name
			vals = []
			for point in graph.Values
				#console.log point.X
				#console.log point.Y
				vals.push([point.X, point.Y])
			chart.addLineName graph.Name
			chart.addLineData(i, vals)
			i++
		chart.draw()

class UDisplayReleaseProgress
	constructor: (@releaseTitle, @divName) ->
		@dates = []
	execute: (jsonData, options) ->
		$(@divName).html('')
		# create array with milestones: milestones['DG'], milestones['FDCG'], etc.They contain objects as {artfct, date, hrs} but possibly multiple with same values since multiple activities are configured
		milestones = jsonData.reduce (acc, x) =>
							id = x.Milestone
							if (not acc[id])
								# add artefact statuses per milestone
								# create array with artefacts: arts['Functional Design'], arts['Final estimates'], etc.They contain objects as {artfct, date, hrs} but possibly multiple with same values since multiple activities are configured
								artefacts = jsonData.reduce (acc, x) =>
													if x.Milestone is id
														if (not acc[x.Artefact])
															# beware! the following creates a property on the acc array with the name of the id value, so: acc.'Functional Design' = [], but then written as acc['FD'] = []
															# seems necessary for dynamic properties
															acc[x.Artefact] = []
														statusDate = new DatePlus(DateFormatter.createJsDateFromJson(x.StatusDate))
														acc[x.Artefact].push({ statusDate:statusDate, hoursRemaining: x.HoursRemaining })
												 acc
											, []
								# beware! the following creates a property on the acc array with the name of the id value, so: acc.'FDCG' = [], but then written as acc['FDCG'] = []
								# necessary for dynamic properties
								acc[id] = artefacts
						 acc
					, []

		# create graph per milestone
		#console.log milestones
		amt = 1
		for k,v of milestones
			#console.log k
			#console.log v
			states = []
			# deduplicate and add up remaining hours per day since multiple activities for the same artefact should be one datapoint with date and hrs remaining
			for key,value of v # use different kind of loop (object loop) since the artefacts are not elements in the array but properties (see comment above)
				totalsPerDay = value.reduce (acc, x) =>
									id = x.statusDate.dateString
									if (not acc[id]) 
										acc[id] = 0
									acc[id] += x.hoursRemaining
								 acc
							, []

				states.push({ artefact: key, statuses: totalsPerDay })
			div = 'graph' + amt
			#console.log div
			chart = new Mnd.TimeChart(@divName, @releaseTitle, k)
			i = 0
			for s in states
				#console.log s
				artefactStatuses = []
				for k2,v2 of s.statuses
					#console.log k2
					#console.log v2
					date = new DatePlus(DateFormatter.createFromString(k2))
					artefactStatuses.push([date.timeStamp(), v2])
				chart.addLineName s.artefact
				chart.addLineData(i, artefactStatuses)
				i++
			chart.draw()
			amt++

# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus
root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow
root.UDisplayPhases = UDisplayPhases
root.UDisplayEnvironments = UDisplayEnvironments
root.UDisplayAbsences = UDisplayAbsences
root.UDisplayPlanningOverview = UDisplayPlanningOverview
root.UDisplayResourcesAvailability = UDisplayResourcesAvailability
root.ULoadAdminReleases = ULoadAdminReleases
root.ULoadAdminProjects = ULoadAdminProjects
root.ULoadAdminMeetings = ULoadAdminMeetings
root.ULoadAdminResources = ULoadAdminResources
root.ULoadAdminDeliverables = ULoadAdminDeliverables
root.ULoadAdminActivities = ULoadAdminActivities
root.ULoadAdminProcesses = ULoadAdminProcesses
root.ULoadPlanResources = ULoadPlanResources
root.ULoadUpdateReleaseStatus = ULoadUpdateReleaseStatus

root.UModifyAssignment = UModifyAssignment
root.UDeleteAssignment = UDeleteAssignment
root.UAddAssignments = UAddAssignments

root.URefreshView = URefreshView
root.UDisplayAssignments = UDisplayAssignments
root.UDisplayReleaseOverview = UDisplayReleaseOverview
root.UDisplayReleaseTimeline = UDisplayReleaseTimeline
root.UDisplayReleasePlanningInTimeline = UDisplayReleasePlanningInTimeline
root.UDisplayReleaseProgress = UDisplayReleaseProgress
root.UDisplayReleaseProgressOverview = UDisplayReleaseProgressOverview
root.UDisplayPlanningForResource = UDisplayPlanningForResource
root.UDisplayPlanningForMultipleResources = UDisplayPlanningForMultipleResources
root.UUpdateScreen = UUpdateScreen
root.URescheduleMilestone = URescheduleMilestone
root.UReschedulePhase = UReschedulePhase
root.UUpdateDeliverableStatus = UUpdateDeliverableStatus
root.UDisplayBurndown = UDisplayBurndown
root.UCreateVisualCuesForGates = UCreateVisualCuesForGates
root.UCreateVisualCuesForAbsences = UCreateVisualCuesForAbsences
root.ULoadAdminEnvironments = ULoadAdminEnvironments
root.UPlanEnvironment = UPlanEnvironment
root.UUnAssignEnvironment = UUnAssignEnvironment
root.UDisplayEnvironmentsGraph = UDisplayEnvironmentsGraph
root.UDisplayPlannedHoursPerActivityArtefactProject = UDisplayPlannedHoursPerActivityArtefactProject

root.UCalculateNeededResources = UCalculateNeededResources





