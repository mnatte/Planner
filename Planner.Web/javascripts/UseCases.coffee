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
		# track added teammembers per project
		projectMembers = []

		# fill release object
		@release = new Release(DateFormatter.createJsDateFromJson(data.StartDate), DateFormatter.createJsDateFromJson(data.EndDate), data.Title)
		# add phases
		for phase in data.Phases
			@release.addPhase new Phase(DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title)
		# add backlog
		for feat in data.Backlog
			@release.addFeature new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project.ShortName, feat.RemainingHours, feat.Title, feat.Status)
			# add team member per project through backlog per project
			for member in feat.Project.ProjectTeam.TeamMembers when "#{member.Initials}_#{feat.Project.ShortName}" not in projectMembers
				# console.log("ADD TEAMMEMBERS TO PROJECT")
				teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Function)
				teamMember.focusFactor = member.FocusFactor
				teamMember.memberProject = feat.Project.ShortName
				# add team member absences
				for absence in member.PeriodsAway when DateFormatter.createJsDateFromJson(absence.EndDate) < @release.endDate or DateFormatter.createJsDateFromJson(absence.StartDate) >= @release.startDate
					teamMember.addAbsence(new Phase(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title))
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
		restPeriod = new Phase(today, @phase.endDate, @phase.title)
		# console.log "period: #{restPeriod}"
		# TODO: subtract absence days
		absentHours = 0
		for absence in @teamMember.periodsAway
			# days away between today or startdate of phase and enddate of either absence or phase
			if (absence.endDate < restPeriod.endDate) 
				endDate = absence.endDate 	
			else 
				endDate = restPeriod.endDate
			if (absence.startDate > today) 
				startDate = absence.startDate
			else
				startDate = today 	
			periodAway = new Phase(startDate, endDate, "Absence in phase")
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
		
# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus
root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow
root.UDisplayPhases = UDisplayPhases

