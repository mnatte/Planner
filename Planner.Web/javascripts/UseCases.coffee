#require release.js
#require releaseViewmodel.js
#require knockout 2.0.0.js

# access (for browser)
root = global ? window

class HLoadReleases
	execute: (data) ->
		releases = []
		# fill release collection
		for release in data
			@release = new Release(release.Id, DateFormatter.createJsDateFromJson(release.StartDate), DateFormatter.createJsDateFromJson(release.EndDate), release.Title, release.TfsIterationPath)
			# add phases
			for phase in release.Phases
				#console.log phase
				@release.addPhase new Release(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath, release.Id)
			releases.push @release
		releases

class UDisplayReleaseStatus
	constructor: ->
		Release.extend(RGroupBy)
		Resource.extend(RTeamMember)
	# use AJAX data in executing use case
	execute: (data) ->
		# track added teammembers per project
		projectMembers = []

		# fill release object
		@release = new Release(data.Id, DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title, data.TfsIterationPath)
		# add phases
		for phase in data.Phases
			@release.addPhase new Phase(phase.Id, DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title, phase.TfsIterationPath)
		console.log @release
		# add backlog
		for feat in data.Backlog
			@release.addFeature new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project.ShortName, feat.RemainingHours, feat.Title, feat.Status)
			# add team member per project through backlog per project
			for member in feat.Project.ProjectTeam.TeamMembers when "#{member.Initials}_#{feat.Project.ShortName}" not in projectMembers
				# console.log("ADD TEAMMEMBERS TO PROJECT")
				teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Email, member.PhoneNumber, member.Company, member.Function)
				teamMember.focusFactor = member.FocusFactor
				teamMember.memberProject = feat.Project.ShortName
				# add team member absences
				for absence in member.PeriodsAway when DateFormatter.createJsDateFromJson(absence.EndDate) < @release.endDate or DateFormatter.createJsDateFromJson(absence.StartDate) >= @release.startDate
					teamMember.addAbsence(new Period(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title))
				@release.addResource teamMember
				# mark teamMember as added to project
				projectMembers.push("#{member.Initials}_#{feat.Project.ShortName}")

				# console.log(projectMembers)
				# console.log(teamMember.memberProject)

		# create aggregations by RGroupBy role
		@release.group 'project', @release.backlog
		@release.group 'state', @release.backlog
		@release.group 'memberProject', @release.resources

		@viewModel = new ReleaseViewmodel(@release)
		ko.applyBindings(@viewModel)
		# show charts
		showStatusChart(@viewModel.statusData())
		# pattern matching
		# {projectNames, remainingHours, availableHours, balanceHours} = @viewModel.hourBalance()
		# showHoursChart(projectNames, remainingHours, availableHours, balanceHours)
		showTableChart()


class UGetAvailableHoursForTeamMemberFromNow
	constructor: (@teamMember, @phase) ->
	execute: ->
		# console.log "available hours for: #{@teamMember.initials}"
		# console.log "in phase: #{@phase.toString()}"
		# set start date of phase to Now
		today = new Date()
		restPeriod = new Period(today, @phase.endDate.date, @phase.title)
		# console.log "period: #{restPeriod}"
		# TODO: subtract absence days
		absentHours = 0
		for absence in @teamMember.periodsAway
			# days away between today or startdate of phase and enddate of either absence or phase
			if (absence.endDate.date < restPeriod.endDate.date) 
				endDate = absence.endDate.date 	
			else 
				endDate = restPeriod.endDate.date
			if (absence.startDate.date > today) 
				startDate = absence.startDate.date
			else
				startDate = today 	
			periodAway = new Period(startDate, endDate, "Absence in phase")
			# console.log "periodAway: #{periodAway.toString()}"
			absentHours += periodAway.workingHours()
		# console.log "absentHours: #{absentHours}"
		availableHours = restPeriod.workingHours() - absentHours
		# console.log "availableHours: #{availableHours}"
		# console.log "corrected with focusfactor #{@teamMember.focusFactor}: #{@teamMember.focusFactor * availableHours}"
		@teamMember.focusFactor * availableHours

class UDisplayPhases
	constructor: ->
	execute: (data) ->
		@viewModel = new PhasesViewmodel()
		@viewModel.load data
		ko.applyBindings(@viewModel)

class ULoadAdminReleases
	constructor: ->
	execute: (data) ->
		loadReleases = new HLoadReleases()
		releases = loadReleases.execute(data)
		@viewModel = new AdminReleaseViewmodel(releases)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminProjects
	constructor: ->
	execute: (data) ->
		projects = Project.createCollection data
		@viewModel = new AdminProjectViewmodel(projects)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadAdminResources
	constructor: ->
	execute: (data) ->
		resources = Resource.createCollection data
		@viewModel = new AdminResourceViewmodel(resources)
		@viewModel.selectItem @viewModel.allItems()[0]
		ko.applyBindings(@viewModel)

class ULoadPlanResources
	constructor: ->
	execute: (releases, projects) ->
		#console.log releases
		#console.log projects
		loadReleases = new HLoadReleases()
		releases = loadReleases.execute(releases)
		projects = Project.createCollection projects
		@viewModel = new PlanResourcesViewmodel(releases, projects)
		@viewModel.selectRelease @viewModel.allReleases()[0]
		ko.applyBindings(@viewModel)
		
# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus
root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow
root.UDisplayPhases = UDisplayPhases
root.HLoadReleases = HLoadReleases
root.ULoadAdminReleases = ULoadAdminReleases
root.ULoadAdminProjects = ULoadAdminProjects
root.ULoadAdminResources = ULoadAdminResources
root.ULoadPlanResources = ULoadPlanResources

