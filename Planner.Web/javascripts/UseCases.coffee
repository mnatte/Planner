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
		timeline = new Mnd.Timeline(@viewModel.showPhases)
		timeline.draw()
		#drawTimeline(@viewModel.showPhases)

class UDisplayAbsences
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection(data)
		#console.log releases
		@viewModel = new AbsencesViewmodel(resources)
		@viewModel.load resources.sort()
		ko.applyBindings(@viewModel)
		timeline = new Mnd.Timeline(@viewModel.showAbsences, @viewModel.selectedTimelineItem)
		timeline.draw()
		#drawTimeline(@viewModel.showAbsences, @viewModel.selectedTimelineItem)

class UDisplayAssignments
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection(data)
		@viewModel = new AssignmentsViewmodel(resources)
		@viewModel.load resources.sort()
		ko.applyBindings(@viewModel)
		timeline = new Mnd.Timeline(@viewModel.showAssignments, @viewModel.selectedTimelineItem)
		timeline.draw()
		#drawTimeline(@viewModel.showAssignments, @viewModel.selectedTimelineItem)

class UReloadAbsenceInTimeline
	constructor: (@allAbsences, @index, @refreshedTimelineItem) ->
	execute: ->
		timeline = new Mnd.Timeline(allAbsences, refreshedTimelineItem)
		timeline.draw()
		#drawTimeline(allAbsences, refreshedTimelineItem)

class ULoadAdminReleases
	constructor: ->
	execute: (jsonRels, jsonProjects, jsonDeliverables) ->
		releases = Release.createCollection(jsonRels)
		projects = Project.createCollection jsonProjects
		deliverables = Deliverable.createCollection jsonDeliverables
		@viewModel = new AdminReleaseViewmodel(releases, projects, deliverables)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		#@viewModel.selectPhase @viewModel.allReleases()[0].phases[0]
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
		#@viewModel = new PlanResourcesViewmodel(releases)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		ko.applyBindings(@viewModel)

class UModifyResourceAssignment
	constructor: (@assignment, @updateViewUsecase) ->
	execute: ->
		console.log 'execute use case'
		serialized = @assignment.toFlatJSON()
		json = ko.toJSON(serialized)
		console.log json
		#@assignment.save("/planner/Resource/Assignments/Save", json, (data) => @refreshData(data))
	refreshData: (resourceData) ->
		newResource = Resource.create resourceData
		@updateViewUsecase.newResource = newResource
		#useCase = new URefreshView(@viewModelObservableCollection, newResource, @checkPeriod, @viewModelObservableGraph, @viewModelObservableForm)
		#useCase.execute()
		@updateViewUsecase.execute()

class URefreshView
	constructor: (@viewModelObservableCollection, @newItem, @checkPeriod, @viewModelObservableGraph, @viewModelObservableForm) ->
	execute: ->
		#console.log resourceData
		#console.log resource
		#console.log @viewModelObservableCollection() 
		oldItem = r for r in @viewModelObservableCollection() when r.id is @newItem.id
		#console.log oldResource
		index = @viewModelObservableCollection().indexOf(oldItem)
		#console.log index
		#console.log oldResource
		resWithAssAndAbsInDate = @newItem
		resWithAssAndAbsInDate.assignments = (a for a in @newItem.assignments when a.period.overlaps(@checkPeriod))
		resWithAssAndAbsInDate.periodsAway = (a for a in @newItem.periodsAway when a.overlaps(@checkPeriod))
		#console.log resWithAssAndAbsInDate
		@viewModelObservableGraph resWithAssAndAbsInDate
		@viewModelObservableForm null
		# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
		@viewModelObservableCollection.splice index, 1, @newItem

class URefreshViewAfterCheckPeriod
	constructor: (@checkPeriod, @viewModelObservableGraph, @viewModelObservableForm) ->
	execute: ->
		@viewModelObservableGraph null
		@viewModelObservableForm null

# show Release planning

class UDisplayReleaseOverview
	constructor: ->
	execute: (rels, resources, activities) ->
		releases = Release.createCollection(rels)
		allResources = Resource.createCollection(resources)
		allActivities = Activity.createCollection(activities)
		console.log releases
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

class UPlanResource
	constructor: (@resource, @release, @project, @milestone, @deliverable, @activity, @period, @focusFactor) ->
	execute: ->
		Resource.extend RTeamMember
		@resource.plan(@release, @project, @milestone, @deliverable, @activity, @period, @focusFactor)

class UModifyAssignment
	# @assignment contains the data to persist. @viewModelObservableCollection is the collection to replace the old item in
	# @selectedObservable is the refreshed item itself, set here and used in callback to refresh the view on its properties
	# @updateViewUsecase is the callback usecase, @observableShowform is the observable used for whether the form is displayed
	constructor: (@assignment, @viewModelObservableCollection, @selectedObservable, @updateViewUsecase, @observableShowform) ->
	execute: ->
		console.log 'execute UModifyAssignment'
		console.log @assignment
		#serialized = @assignment.toJSON()
		json = ko.toJSON(@assignment)
		console.log json
		# @assignment.save("/planner/Resource/Plan", json, (data) => @refreshData(data))
	refreshData: (json) ->
		console.log json
		freshRelease = Release.create json
		# replace old item in collection for new one
		oldItem = r for r in @viewModelObservableCollection() when r.id is freshRelease.id
		#console.log oldItem
		index = @viewModelObservableCollection().indexOf(oldItem)
		#console.log index
		@observableShowform null
		# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
		@viewModelObservableCollection.splice index, 1, freshRelease
		@selectedObservable freshRelease
		@updateViewUsecase.execute()

class UDeleteResourceAssignment
	constructor: (@assignment, @updateViewUsecase) ->
	execute: ->
		console.log 'execute use case'
		serialized = @assignment.toFlatJSON()
		json = ko.toJSON(serialized)
		console.log json
		# since we POST a graph we cannot use HTTP DELETE. The RCrud method 'save' is abused here
		@assignment.save("/planner/Resource/Assignments/Delete", json, (data) => @refreshData(data))
	refreshData: (resourceData) ->
		newResource = Resource.create resourceData
		@updateViewUsecase.newResource = newResource
		@updateViewUsecase.execute()

class UUpdateScreen
	constructor: (@usecases) ->
	execute: ->
		for uc in @usecases
			uc.execute()

class UDisplayReleaseTimeline
	# depends on timeline.js and having an HTML div with id 'mytimeline'
	constructor: (@observableRelease, @observableTimelineSource) ->
	execute: ->
		@displayData = []
		console.log 'execute use case UDisplayReleaseTimeline'
		for ph in @observableRelease().phases
			#cont = '<span style="background-color:pink" />' + ph.title + '</span>'
			cont = ph.title
			obj = {group: @observableRelease().title, start: ph.startDate.date, end: ph.endDate.date, content:  cont, info: ph.toString() }
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
								acc.push {activityTitle :x.activity.title, hrs: x.hoursRemaining, planned: x.assignedResources.reduce ((acc, x) -> acc + x.resourceAvailableHours()), 0 }
								acc
							, []
					for act in activities
						if act.hrs > act.planned
							icon = '<span class="icon icon-warning" />'
							style = 'style="color: red"'
						else
							style = 'style="color: green"'
						descr += '<li ' + style + '>' + act.activityTitle + ': ' + act.hrs + ' hours remaining, ' + act.planned + ' hours planned</li>'
					descr += '</ul>' # /activities
					descr += '</li>' # /project
				descr += '</ul>' # /projects
			descr += '</li>' # /deliverable
			descr += '</ul>' # /deliverables
			obj = {group: @observableRelease().title, start: ms.date.date, content: ms.title + '<br />' + icon, info: ms.date.dateString + ' - ' + ms.time + '<br />' + descr, dataObject: ms}
			@displayData.push obj
		showData = @displayData.sort((a,b)-> a.start - b.end)
		console.log showData
		timeline = new Mnd.Timeline(showData, @observableTimelineSource, "100%", "200px", "releaseTimeline", "releaseDetails")
		timeline.draw()

class UDisplayReleasePlanningInTimeline
	# depends on timeline.js
	constructor: (@observableRelease, @observableTimelineItem) ->
	execute: ->
		@trackAssignments = []
		@displayData = []
		releaseTitle = @observableRelease().title
		console.log 'execute use case UDisplayReleasePlanningInTimeline'
		console.log @observableRelease()
		uniqueAsses = []
		for ms in @observableRelease().milestones
			for del in ms.deliverables
				console.log del
				for proj in del.scope
					for activity in proj.workload
						for assignment in activity.assignedResources
							console.log assignment
							dto = assignment # trick for adding info: dto.person = resource
							resource = @createRowItem(assignment.resource.fullName(), 0)

							obj = {group: resource, start: assignment.period.startDate.date, end: assignment.period.endDate.date, content: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.project.title, info: assignment.activity.title + ' [' + assignment.focusFactor + ']' + ' ' + assignment.deliverable.title + ' ' + assignment.period.toString(), dataObject: dto}
							@displayData.push obj
		showData = @displayData.sort((a,b)-> a.start - b.end)
		timeline = new Mnd.Timeline(showData, @observableTimelineItem, "100%", "500px", "resourcePlanning", "assignmentDetails")
		timeline.draw()
	createRowItem: (item, index) ->
		identifier = item + index
		if @trackAssignments.indexOf(identifier) is -1
			@trackAssignments.push(identifier)
			item + '[' + index + ']'
		else
			index++
			@createRowItem item, index

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

class UDisplayReleaseProgress
	constructor: (@releaseTitle) ->
		@dates = []
	execute: (jsonData, options) ->
		$('#graph0').html('')
		$('#graph1').html('')
		$('#graph2').html('')
		$('#graph3').html('')
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
		amt = 0
		for k,v of milestones
			console.log k
			console.log v
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
			console.log div
			chart = new Mnd.TimeChart(div, @releaseTitle, k)
			i = 0
			for s in states
				console.log s
				artefactStatuses = []
				for k2,v2 of s.statuses
					console.log k2
					console.log v2
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
root.UDisplayAbsences = UDisplayAbsences
root.UDisplayPlanningOverview = UDisplayPlanningOverview
root.UDisplayResourcesAvailability = UDisplayResourcesAvailability
root.ULoadAdminReleases = ULoadAdminReleases
root.ULoadAdminProjects = ULoadAdminProjects
root.ULoadAdminMeetings = ULoadAdminMeetings
root.ULoadAdminResources = ULoadAdminResources
root.ULoadAdminDeliverables = ULoadAdminDeliverables
root.ULoadAdminActivities = ULoadAdminActivities
root.ULoadPlanResources = ULoadPlanResources
root.ULoadUpdateReleaseStatus = ULoadUpdateReleaseStatus
root.UModifyResourceAssignment = UModifyResourceAssignment
root.UModifyAssignment = UModifyAssignment
root.UDeleteResourceAssignment = UDeleteResourceAssignment
root.URefreshView = URefreshView
root.UDisplayAssignments = UDisplayAssignments
root.UDisplayReleaseOverview = UDisplayReleaseOverview
root.UDisplayReleaseTimeline = UDisplayReleaseTimeline
root.UDisplayReleasePlanningInTimeline = UDisplayReleasePlanningInTimeline
root.UDisplayReleaseProgress = UDisplayReleaseProgress
root.UDisplayReleaseProgressOverview = UDisplayReleaseProgressOverview
root.UPlanResource = UPlanResource
root.UDisplayPlanningForResource = UDisplayPlanningForResource
root.UUpdateScreen = UUpdateScreen





