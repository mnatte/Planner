# access (for browser)
root = global ? window

# requires jQuery 1.6.4 or later
class Ajax
	constructor: -> 
	load: (callback) ->
		url = "/planner/Release/GetRelease"
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
		url = "/planner/Resource/GetResources"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log "Resources data loaded"
				callback data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX Releases error: #{status}"
	test: ->
		console.log "testing AJAX class"

# export to root object
root.Ajax = Ajax