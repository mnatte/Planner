# access (for browser)
root = global ? window

class UDisplayReleaseStatus
	constructor: ->
		Release.extend(RGroupBy);
	# use AJAX data in executing use case
	execute: (data) ->
		# fill release object
		@release = new Release(DateFormatter.formatJsonDate(data.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(data.EndDate, "dd/MM/yyyy"), data.WorkingDays, data.Title)
		for phase in data.Phases
			@release.addPhase new Phase(DateFormatter.formatJsonDate(phase.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(phase.EndDate, "dd/MM/yyyy"), phase.WorkingDays, phase.Title)
		for feat in data.Backlog
			@release.addFeature new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project, feat.RemainingHours, feat.Title, feat.Status)
		
		# create aggregations by RGroupBy role
		@release.group 'project', @release.backlog
		@release.group 'state', @release.backlog
		for set in @release.sets when set.groupedBy == "project"
			# console.log set.label
			set.link = "#" + set.label
			set.totalHours = 0
			for ft in set.items
				set.totalHours += ft.remainingHours

		statusData = []
		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			data = []
			data.push(statusgroup.label)
			data.push(statusgroup.items.length)
			statusData.push(data)
			# console.log data

		# console.log @release.sets.length
		ko.applyBindings(@release)
		showStatusChart(statusData)
		
# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus

