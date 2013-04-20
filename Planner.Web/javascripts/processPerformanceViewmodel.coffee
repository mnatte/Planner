# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ProcessPerformanceViewmodel
	constructor: ->
		@selectedMilestone = ko.observable()
		@velocity = ko.observable()

	#viewReleaseProgress: (selectedRelease) =>
	#	console.log selectedRelease
	#	uc = new UDisplayReleaseProgress(selectedRelease.title)
	#	ajax = new Ajax()
	#	ajax.getReleaseProgress(selectedRelease.id, (data) -> uc.execute(data))


# export to root object
root.ProcessPerformanceViewmodel = ProcessPerformanceViewmodel