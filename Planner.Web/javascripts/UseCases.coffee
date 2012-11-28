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
		drawTimeline(@viewModel.showPhases)

class UDisplayAbsences
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection(data)
		#console.log releases
		@viewModel = new AbsencesViewmodel(resources)
		@viewModel.load resources.sort()
		ko.applyBindings(@viewModel)
		drawTimeline(@viewModel.showAbsences, @viewModel.selectedTimelineItem)

class UReloadAbsenceInTimeline
	constructor: (@allAbsences, @index, @refreshedTimelineItem) ->
	execute: ->
		drawTimeline(allAbsences, refreshedTimelineItem)

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
		@assignment.save("/planner/Resource/Assignments/Save", json, (data) => @refreshData(data))
	refreshData: (resourceData) ->
		newResource = Resource.create resourceData
		@updateViewUsecase.newResource = newResource
		#useCase = new URefreshView(@viewModelObservableCollection, newResource, @checkPeriod, @viewModelObservableGraph, @viewModelObservableForm)
		#useCase.execute()
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
	
class URefreshView
	constructor: (@viewModelObservableCollection, @newResource, @checkPeriod, @viewModelObservableGraph, @viewModelObservableForm) ->
	execute: ->
		#console.log resourceData
		#console.log resource
		#console.log @viewModelObservableCollection() 
		oldResource = r for r in @viewModelObservableCollection() when r.id is @newResource.id
		#console.log oldResource
		index = @viewModelObservableCollection().indexOf(oldResource)
		#console.log index
		#console.log oldResource
		resWithAssAndAbsInDate = @newResource
		resWithAssAndAbsInDate.assignments = (a for a in @newResource.assignments when a.period.overlaps(@checkPeriod))
		resWithAssAndAbsInDate.periodsAway = (a for a in @newResource.periodsAway when a.overlaps(@checkPeriod))
		#console.log resWithAssAndAbsInDate
		@viewModelObservableGraph resWithAssAndAbsInDate
		@viewModelObservableForm null
		# i = index of item to remove, 1 is amount to be removed, rel is item to be inserted there
		@viewModelObservableCollection.splice index, 1, @newResource
		

# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus
root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow
root.UDisplayPhases = UDisplayPhases
root.UDisplayAbsences = UDisplayAbsences
root.UDisplayPlanningOverview = UDisplayPlanningOverview
root.UDisplayResourcesAvailability = UDisplayResourcesAvailability
root.ULoadAdminReleases = ULoadAdminReleases
root.ULoadAdminProjects = ULoadAdminProjects
root.ULoadAdminResources = ULoadAdminResources
root.ULoadAdminDeliverables = ULoadAdminDeliverables
root.ULoadAdminActivities = ULoadAdminActivities
root.ULoadPlanResources = ULoadPlanResources
root.ULoadUpdateReleaseStatus = ULoadUpdateReleaseStatus
root.UModifyResourceAssignment = UModifyResourceAssignment
root.UDeleteResourceAssignment = UDeleteResourceAssignment
root.URefreshView = URefreshView



