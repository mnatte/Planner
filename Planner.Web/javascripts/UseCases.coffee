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
		for phase in data.Phases
			@release.addPhase new Phase(DateFormatter.createJsDateFromJson(phase.StartDate), DateFormatter.createJsDateFromJson(phase.EndDate), phase.Title)
		for feat in data.Backlog
			@release.addFeature new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project.ShortName, feat.RemainingHours, feat.Title, feat.Status)
			for member in feat.Project.ProjectTeam.TeamMembers when "#{member.Initials}_#{feat.Project.ShortName}" not in projectMembers
				# console.log("ADD TEAMMEMBERS TO PROJECT")
				teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Function)
				teamMember.focusFactor = member.FocusFactor
				teamMember.memberProject = feat.Project.ShortName
				for absence in member.PeriodsAway when DateFormatter.createJsDateFromJson(absence.EndDate) < @release.endDate or DateFormatter.createJsDateFromJson(absence.StartDate) >= @release.startDate
					teamMember.addAbsence(new Phase(DateFormatter.createJsDateFromJson(absence.StartDate), DateFormatter.createJsDateFromJson(absence.EndDate), absence.Title))
				@release.addResource teamMember
				projectMembers.push("#{member.Initials}_#{feat.Project.ShortName}")

				# console.log(projectMembers)
				# console.log(teamMember.memberProject)

		# create aggregations by RGroupBy role
		@release.group 'project', @release.backlog
		@release.group 'state', @release.backlog
		@release.group 'memberProject', @release.resources

		statusData = []
		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			data = []
			data.push(statusgroup.label)
			data.push(statusgroup.items.length)
			statusData.push(data)
			# console.log data

		for set in @release.sets when set.groupedBy == "project"
			# console.log set.label
			set.link = "#" + set.label
			set.totalHours = 0
			for ft in set.items
				set.totalHours += ft.remainingHours unless ft.state is "Descoped" 
		
		projects = []
		for set in @release.sets when set.groupedBy == "memberProject"
			projectHours = {}
			console.log "memberProject: #{set.label} #{set.items.length} members"
			phase = (item for item in @release.phases when item.title == "Ontwikkelfase")[0]
			set.availableHours = 0
			for member in set.items
				# console.log "#{member.initials} hours per week: #{member.hoursPerWeek}"
				uGetHours = new UGetAvailableHoursForTeamMemberFromNow(member, phase)
				set.availableHours += uGetHours.execute()
			projectHours.project = set.label 
			projectHours.available = set.availableHours 
			# lookup project in groupedBy project set for remaining hours
			for projset in @release.sets when projset.groupedBy == "project" and projset.label == set.label
				# console.log "projset: #{projset.totalHours}"
				projectHours.workload = projset.totalHours
			
			projects.push(projectHours)
		console.log projects

		projectNames = []
		remainingHours = []
		availableHours = []
		balanceHours = []
		for item in projects
			# pattern matching, works only when local vars have same name as properties of item
			{project, workload, available} = item
			projectNames.push(project)
			remainingHours.push(workload)
			availableHours.push(available)
			balanceHours.push(available - workload)

		# console.log @release.sets.length
		ko.applyBindings(@release)
		showStatusChart(statusData)
		showHoursChart(projectNames, remainingHours, availableHours, balanceHours)


class UGetAvailableHoursForTeamMemberFromNow
	constructor: (@teamMember, @phase) ->
	execute: ->
		console.log "available hours for: #{@teamMember.initials}"
		console.log "in phase: #{@phase.toString()}"
		# set start date of phase to Now
		today = new Date()
		restPeriod = new Phase(today, @phase.endDate, @phase.title)
		console.log "period: #{restPeriod}"
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
			console.log "periodAway: #{periodAway.toString()}"
			absentHours += periodAway.workingHours()
		console.log "absentHours: #{absentHours}"
		availableHours = restPeriod.workingHours() - absentHours
		console.log "availableHours: #{availableHours}"
		console.log "corrected with focusfactor #{@teamMember.focusFactor}: #{@teamMember.focusFactor * availableHours}"
		@teamMember.focusFactor * availableHours
		
# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus
root.UGetAvailableHoursForTeamMemberFromNow = UGetAvailableHoursForTeamMemberFromNow

