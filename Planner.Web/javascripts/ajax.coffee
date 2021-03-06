# access (for browser)
root = global ? window

# requires jQuery 1.6.4 or later
class Ajax
	constructor: -> 
		$.ajaxSetup({
			beforeSend: -> 
				$.blockUI({ css: { 
					border: 'none', 
					padding: '15px', 
					backgroundColor: '#000', 
					'-webkit-border-radius': '10px', 
					'-moz-border-radius': '10px', 
					opacity: .5, 
					color: '#fff'
				},
				message:  '<img src="images/ajax-loader.gif" />'  })
			,
			complete: ->
				setTimeout $.unblockUI, 200
		})
	loadRelease: (releaseId, callback) ->
		url = "/planner/Release/GetReleaseById/" + releaseId
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "AJAX data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	loadPhases: (callback) ->
		url = "/planner/Phases/GetPhases"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Phases data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Phases error: #{status}"
	submitRelease: (data) ->
		url = "/planner/Release/Create"
	getReleaseSummaries: (callback) ->
		url = "/planner/Release/GetReleaseSummaries"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Releases data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases error: #{status}"
	getProjects: (callback) ->
		url = "/planner/Project/GetProjects"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Projects data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases error: #{status}"
	getResources: (callback) ->
		url = "/planner/Resource/GetItems"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Resources data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases error: #{status}"
	getDeliverables: (callback) ->
		url = "/planner/Deliverable/GetItems"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Deliverables data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Deliverables error: #{status}"
	getActivities: (callback) ->
		url = "/planner/Deliverable/GetAllActivities"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Activities data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Deliverables error: #{status}"
	getAssignedResources: (phaseId, projectId, callback) ->
		url = "/planner/ResourceAssignment/Assignments/" + phaseId + "/" + projectId
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Resource Assignments data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases status: #{status}"
				console.log "AJAX Releases XHR: #{XHR}"
				console.log "AJAX Releases errorThrown: #{errorThrown}"
	getAssignedResourcesForDeliverable: (phaseId, projectId, milestoneId, deliverableId, callback) ->
		url = "/planner/ResourceAssignment/Assignments/" + phaseId + "/" + projectId + "/" + milestoneId + "/" + deliverableId
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Resource Assignments data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases status: #{status}"
				console.log "AJAX Releases XHR: #{XHR}"
				console.log "AJAX Releases errorThrown: #{errorThrown}"
	getAssignedResourcesForRelease: (phaseId, callback) ->
		url = "/planner/ResourceAssignment/Assignments/Release/" + phaseId
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Resource Assignments data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases status: #{status}"
				console.log "AJAX Releases XHR: #{XHR}"
				console.log "AJAX Releases errorThrown: #{errorThrown}"
	mailPlanning: (url, jsonData, callback) ->
				$.ajax url,
					dataType: "json"
					data: jsonData
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{data} mailed"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX MAIL error: #{errorThrown}"
	getReleaseProgress: (phaseId, milestoneId, callback) ->
		url = "/planner/Release/Progress/Milestone/" + phaseId + "/" + milestoneId
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Release progress data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX status: #{status}"
				console.log XHR
				console.log "AJAX errorThrown: #{errorThrown}"
	getReleasesForProgressReport: (callback) ->
		url = "/planner/Release/GetReleaseSnapshotsWithProgressStatus"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Release snapshots data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX status: #{status}"
				console.log "AJAX XHR: #{XHR}"
				console.log "AJAX errorThrown: #{errorThrown}"
	getMeetings: (callback) ->
		url = "/planner/Meeting/GetItems"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Meetings data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases error: #{status}"
	getProcessPerformance: (releaseId, callback) ->
		url = "/planner/Release/Performance/" + releaseId
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Process performance data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases error: #{status}"
	createCuesForGates: (amountDays, callback) ->
		url = "/planner/Release/Process/" + amountDays
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "createCuesForGates succesfully called"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	createCuesForAbsences: (amountDays, callback) ->
		url = "/planner/Resource/Absences/ComingDays/" + amountDays
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "createCuesForAbsences succesfully called"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	getEnvironmentsPlanning: (callback) ->
		url = "/planner/Environment/Planning"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "environments planning succesfully called"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	getVersions: (callback) ->
		url = "/planner/Environment/Versions"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "versions succesfully called"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	getProcesses: (callback) ->
		url = "/planner/Process"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "processes data succesfully called"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	getEnvironments: (callback) ->
		url = "/planner/Environment/All"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "environments succesfully loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
# export to root object
root.Ajax = Ajax