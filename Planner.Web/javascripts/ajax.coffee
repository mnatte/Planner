# access (for browser)
root = global ? window

class Ajax
	constructor: -> 
	load: ->
		url = "/Release/GetRelease"
		$.ajax url,
			dataType: "json"
			type: "GET"
			success: (data, status, XHR) ->
				console.log data
			error: (XHR, status, errorThrown) ->
				console.log "AJAX error: #{status}"
	test: ->
		console.log "testing AJAX class"
# export to root object
root.Ajax = Ajax