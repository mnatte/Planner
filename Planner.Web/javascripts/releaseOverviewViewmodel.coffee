# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseOverviewViewmodel
	constructor: (@allReleases) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@inspectRelease = ko.observable()
		@canShowDetails = ko.observable(false)
		@assignments = ko.observableArray()
		@inspectRelease.subscribe((newValue) => 
			console.log newValue
			)
		Resource.extend RTeamMember

	viewReleasePlanning: (selectedRelease) =>
		console.log selectedRelease
		@inspectRelease selectedRelease
		uc = new UDisplayReleaseTimeline(selectedRelease)
		uc.execute()
		uc2 = new UDisplayReleasePlanningInTimeline(selectedRelease)
		uc2.execute()

# export to root object
root.ReleaseOverviewViewmodel = ReleaseOverviewViewmodel