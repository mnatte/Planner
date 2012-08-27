# access (for browser)
root = global ? window

# requires jQuery 1.6.4 or later
class Ajax
	constructor: -> 
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
	test: ->
		console.log "testing AJAX class"

# export to root object
root.Ajax = Ajax