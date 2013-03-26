# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PhasesViewmodel
	constructor: (allReleases) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedPhase = ko.observable()
		@canShowDetails = ko.observable(false)
		@assignments = ko.observableArray()
		@selectedPhase.subscribe((newValue) => 
			loadAssignments newValue.id
			)
		Resource.extend RTeamMember
		@selectedTimelineItem = ko.observable()
		@selectedTimelineItem.subscribe((newValue) => 
			console.log newValue
			)

	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@releases = []
		@displayData = []
		relevantReleases = (a for a in data when a.isCurrent())
		#console.log relevantReleases
		for rel in relevantReleases 
			console.log rel.title + ': ' + rel.endDate.dateString
			for ph in rel.phases
				obj = {group: rel.title, start: ph.startDate.date, end: ph.endDate.date, content: ph.title, info: ph.toString(), dataObject: ph}
				@displayData.push obj
			for ms in rel.milestones
				icon = '<span class="icon icon-milestone" />'
				style = 'style="color: green"'
				descr = '<ul>'
				for del in ms.deliverables
					console.log del.title
					descr += '<li>' + del.title + '<ul>'
					for proj in del.scope
						descr += '<li>' + proj.title
						descr += '<ul>'
						activities = proj.workload.reduce (acc, x) ->
									acc.push {activityTitle :x.activity.title, hrs: x.hoursRemaining, planned: x.assignedResources.reduce ((acc, x) -> acc + x.resourceAvailableHours()), 0 }
									acc
								, []
						for act in activities
							if act.hrs > act.planned
								icon = '<span class="icon icon-warning" />'
								style = 'style="color: red"'
							else
								style = 'style="color: green"'
							descr += '<li ' + style + '>' + act.activityTitle + ': ' + act.hrs + ' hours remaining, ' + act.planned + ' hours planned</li>'
						descr += '</ul>' # /activities
						descr += '</li>' # /project
					descr += '</ul>' # /projects
				descr += '</li>' # /deliverable
				descr += '</ul>' # /deliverables
				obj = {group: rel.title, start: ms.date.date, content: ms.title + '<br />' + icon, info: ms.date.dateString + '<br />' + ms.description + '<br/>' + descr, dataObject: ms}
				@displayData.push obj
		@showPhases = @displayData.sort((a,b)-> a.start - b.end)

	setAssignments: (jsonData) =>
		@assignments.removeAll()
		@assignments AssignedResource.createCollection(jsonData)

	loadAssignments: (releaseId) ->
        ajax = new Ajax()
        ajax.getAssignedResourcesForRelease(releaseId, @setAssignments)
		
	closeDetails: =>
        @canShowDetails(false)

	selectPhase: (data) =>
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

# export to root object
root.PhasesViewmodel = PhasesViewmodel