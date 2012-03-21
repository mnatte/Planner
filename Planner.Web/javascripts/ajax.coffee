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
	test: ->
		console.log "testing AJAX class"

# export to root object
root.Ajax = Ajax