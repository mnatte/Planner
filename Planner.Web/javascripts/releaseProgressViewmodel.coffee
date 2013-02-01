# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseProgressViewmodel
	constructor: (@allReleases) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)

	viewReleaseProgress: (selectedRelease) =>
		console.log selectedRelease
		uc = new UDisplayReleaseProgress(selectedRelease.title)
		ajax = new Ajax()
		ajax.getReleaseProgress(selectedRelease.id, (data) -> uc.execute(data))


# export to root object
root.ReleaseProgressViewmodel = ReleaseProgressViewmodel