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
		@release = new Release(DateFormatter.formatJsonDate(data.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(data.EndDate, "dd/MM/yyyy"), data.WorkingDays, data.Title)
		for phase in data.Phases
			@release.addPhase new Phase(DateFormatter.formatJsonDate(phase.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(phase.EndDate, "dd/MM/yyyy"), phase.WorkingDays, phase.Title)
		for feat in data.Backlog
			@release.addFeature new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project.ShortName, feat.RemainingHours, feat.Title, feat.Status)
			for member in feat.Project.ProjectTeam.TeamMembers when "#{member.Initials}_#{feat.Project.ShortName}" not in projectMembers
				console.log("ADD TEAMMEMBERS TO PROJECT")
				teamMember = new Resource(member.FirstName, member.MiddleName, member.LastName, member.Initials, member.AvailableHoursPerWeek, member.Function)
				teamMember.focusFactor = member.FocusFactor
				teamMember.memberProject = feat.Project.ShortName
				@release.addResource teamMember
				projectMembers.push("#{member.Initials}_#{feat.Project.ShortName}")

				console.log(projectMembers)
				# console.log(teamMember.memberProject)

		# create aggregations by RGroupBy role
		@release.group 'project', @release.backlog
		@release.group 'state', @release.backlog
		@release.group 'memberProject', @release.resources

		for set in @release.sets when set.groupedBy == "project"
			# console.log set.label
			set.link = "#" + set.label
			set.totalHours = 0
			for ft in set.items
				set.totalHours += ft.remainingHours unless ft.state is "Descoped" 

		statusData = []
		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			data = []
			data.push(statusgroup.label)
			data.push(statusgroup.items.length)
			statusData.push(data)
			# console.log data

		for set in @release.sets when set.groupedBy == "memberProject"
			console.log "memberProject: #{set.label} #{set.items.length} members"
			set.availableHours = 0
			for member in set.items
				console.log "#{member.initials} hours per week: #{member.hoursPerWeek}"
				set.availableHours += member.hoursPerWeek * member.focusFactor
			console.log "available hours for #{set.label}: #{set.availableHours}"

		# console.log @release.sets.length
		ko.applyBindings(@release)
		showStatusChart(statusData)
		
# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus

