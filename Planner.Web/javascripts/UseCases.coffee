# access (for browser)
root = global ? window

class UDisplayReleaseStatus
	constructor: ->
		Release.extend(RGroupBy);
	execute: (data) ->
		console.log(data.Title)
		@release = new Release(DateFormatter.formatJsonDate(data.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(data.EndDate, "dd/MM/yyyy"), data.WorkingDays, data.Title)
		for phase in data.Phases
			@release.addPhase new Phase(DateFormatter.formatJsonDate(phase.StartDate, "dd/MM/yyyy"), DateFormatter.formatJsonDate(phase.EndDate, "dd/MM/yyyy"), phase.WorkingDays, phase.Title)
		for feat in data.Backlog
			@release.addFeature new Feature(feat.BusinessId, feat.ContactPerson, feat.EstimatedHours, feat.HoursWorked, feat.Priority, feat.Project, feat.RemainingHours, feat.Title)
		
		@release.group 'project', @release.backlog
		console.log @release.sets.length
		ko.applyBindings(@release);
		$("#tabSection > ul > li > a").first().addClass("active");
		$(".tabs-content > li").first().addClass("active");
# export to root object
root.UDisplayReleaseStatus = UDisplayReleaseStatus

