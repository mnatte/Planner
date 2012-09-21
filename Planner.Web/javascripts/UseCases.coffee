#require release.js
#require releaseViewmodel.js
#require knockout 2.0.0.js

# access (for browser)
root = global ? window

class HLoadReleases
	execute: (data) ->
		# console.log data
		releases = []
		# fill release collection
		for release in data
			rel = Release.create release
			releases.push rel
		releases

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
		loadReleases = new HLoadReleases()
		releases = loadReleases.execute(data)
		#console.log releases
		@viewModel = new PhasesViewmodel(releases)
		@viewModel.load releases.sort((a,b)-> if a.endDate.date > b.endDate.date then 1 else if a.endDate.date < b.endDate.date then -1 else 0)
		ko.applyBindings(@viewModel)
		drawTimeline(@viewModel.showPhases)

class ULoadAdminReleases
	constructor: ->
	execute: (jsonRels, jsonProjects, jsonDeliverables) ->
		loadReleases = new HLoadReleases()
		releases = loadReleases.execute(jsonRels)
		projects = Project.createCollection jsonProjects
		deliverables = Deliverable.createCollection jsonDeliverables
		@viewModel = new AdminReleaseViewmodel(releases, projects, deliverables)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		#@viewModel.selectPhase @viewModel.allReleases()[0].phases[0]
		ko.applyBindings(@viewModel, null, {independentBindings: true})

class ULoadUpdateReleaseStatus
	constructor: ->
	execute: (jsonRels) ->
		loadReleases = new HLoadReleases()
		releases = loadReleases.execute(jsonRels)
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
		loadReleases = new HLoadReleases()
		releases = loadReleases.execute(releases)
		console.log releases
		resources = Resource.createCollection resources
		activities = Activity.createCollection activities
		# console.log resources
		@viewModel = new PlanResourcesViewmodel(releases, resources, activities)
		#@viewModel = new PlanResourcesViewmodel(releases)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		ko.applyBindings(@viewModel)

# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus
root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow
root.UDisplayPhases = UDisplayPhases
root.UDisplayPlanningOverview = UDisplayPlanningOverview
root.HLoadReleases = HLoadReleases
root.ULoadAdminReleases = ULoadAdminReleases
root.ULoadAdminProjects = ULoadAdminProjects
root.ULoadAdminResources = ULoadAdminResources
root.ULoadAdminDeliverables = ULoadAdminDeliverables
root.ULoadAdminActivities = ULoadAdminActivities
root.ULoadPlanResources = ULoadPlanResources
root.ULoadUpdateReleaseStatus = ULoadUpdateReleaseStatus


