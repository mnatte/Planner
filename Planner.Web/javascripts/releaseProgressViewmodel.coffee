# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseProgressViewmodel
	constructor: (@allReleases) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedPhase = ko.observable()
		@selectedMilestone = ko.observable()

	# functions for observable necessary to pass view model data to it from html
	selectPhase: (data) =>
		console.log "selectPhase - function"
		@selectedPhase data
		console.log @selectedPhase.milestones
		# reset selected Milestone and Deliverable
		@selectedMilestone null

	viewReleaseProgress: (milestone) =>
		console.log milestone
		@selectedMilestone milestone
		uc = new UDisplayReleaseProgress(@selectedMilestone().phaseTitle, 'graph1')
		uc2 = new UDisplayBurndown(@selectedMilestone().phaseTitle + ' - ' + @selectedMilestone().title, 'graph0')
		ajax = new Ajax()
		ajax.getReleaseProgress(@selectedMilestone().phaseId, @selectedMilestone().id, (data) -> uc.execute(data.Progress); uc2.execute(data.Burndown))


# export to root object
root.ReleaseProgressViewmodel = ReleaseProgressViewmodel