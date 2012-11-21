# access (for browser)
root = global ? window

RMoveItem = 
	move: (source, target) ->
		# remove item from source
		source.splice(source.indexOf((@)), 1);
		# assign item to target
		target.push(@)
	extended: ->
		@include
			test: "extended with RMoveItem"

RGroupBy = 
	extended: ->
		@include
			sets: []
			group: (property, collection) ->
				# algorithm:
				# 1) create set per propertyValue
				#		i) create set of sets property
				#		ii) iterate over collection
					# remember what sets we have created based on groupby property
					addedSets = []
					# iterate over collection
					for item in collection
						# console.log item
						# add set (with label) to set collection when no set with label propertyValue exists
						unless "#{property}_#{item[property]}" in addedSets
							# console.log("add set with label #{item[property]} and groupedBy #{property}")
							# set has a label, a collection and a link property. link can be used to link to it in UI for tabs for example
							@sets.push(label: item[property], items: [], groupedBy: property)
							addedSets.push("#{property}_#{item[property]}")
							# console.log(addedSets)
						# add item to set when property == propertyValue
						set = (grp for grp in @sets when grp.label == item[property] and grp.groupedBy == property)[0]
						# console.log set
						set.items.push(item)
						# console.log("added #{item} to set #{set.label}")
					@sets

RTeamMember = 
	createSnapshot: (jsonData) ->
		res = new Resource(jsonData.Id, jsonData.FirstName, jsonData.MiddleName, jsonData.LastName, jsonData.Initials, jsonData.AvailableHoursPerWeek, jsonData.Email, jsonData.PhoneNumber)
		res
	extended: ->
		@include
			# default value, just setting focusFactor in target object without specifying it here is enough to set it, but then it can be undefined.
			focusFactor: 0.8
			roles: []
			hoursPlannedIn: (period) ->
				# console.log period.toString()
				hrsPlannedIn = 0
				# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
				overlappingAssignments = (ass for ass in @assignments when ass.period.overlaps(period))
				if(overlappingAssignments? and typeof(overlappingAssignments) isnt 'undefined' and overlappingAssignments.length > 0)
					# somehow "reduce (x,y)" needs a space between name ('reduce') and args
					hrsPlannedIn = (assignment for assignment in overlappingAssignments).reduce (acc, x) ->
							#console.log x
							#console.log(x.period.overlappingPeriod(period).remainingWorkingDays())
							days = x.period.overlappingPeriod(period).remainingWorkingDays()
							hours = Math.round(days * 8 * x.focusFactor)
							#console.log hours
							acc + hours
						, 0
				Math.round(hrsPlannedIn)
			availableHoursForPlanning: (period) ->
				#console.log @hoursAvailable(period)
				#console.log @hoursPlannedIn(period)
				maxHours = Math.round(@hoursAvailable(period) * 0.8)
				hrsAvailable = Math.round(maxHours - @hoursPlannedIn(period))
				#console.log hrsAvailable
				if hrsAvailable < 0 then 0 else hrsAvailable
			hoursAbsent: (period) ->
				absent = 0
				# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
				overlappingAbsences = (absence for absence in @periodsAway when absence.overlaps(period))
				if(overlappingAbsences? and typeof(overlappingAbsences) isnt 'undefined' and overlappingAbsences.length > 0)
					absent = (absence.overlappingPeriod(period) for absence in overlappingAbsences).reduce (acc, x) ->
							result = x.remainingWorkingDays()
							acc + result
						, 0
				Math.round(absent * 8)
			hoursAvailable: (period) ->
				absent = 0
				# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
				overlappingAbsences = (absence for absence in @periodsAway when absence.overlaps(period))
				# somehow "reduce (x,y)" needs a space between name ('reduce') and args
				if(overlappingAbsences? and typeof(overlappingAbsences) isnt 'undefined' and overlappingAbsences.length > 0)
					absent = (absence.overlappingPeriod(period) for absence in overlappingAbsences).reduce (acc, x) ->
							#console.log x
							result = Math.round(x.remainingWorkingDays())
							acc + result
						, 0
				amtDays = period.remainingWorkingDays() - absent
				if amtDays < 0 then amtDays = 0
				available = Math.round(amtDays * 8)
				available
			isOverPlanned: (period) ->
				maxHours = Math.round(@hoursAvailable(period) * 0.8)
				maxHours < @hoursPlannedIn(period)

#RAbsenceTimelineItem = 
#	extended: ->
#		@include
#			focusFactor: 0.8
#			roles: []

RCrud = 
	extended: ->
		@include
			save: (url, jsonData, callback) ->
				$.ajax url,
					dataType: "json"
					data: jsonData
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{jsonData} saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"
			delete: (url, callback) ->
				$.ajax url,
					#dataType: "json"
					#data: jsonData
					type: "DELETE"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{url} called succesfully"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX DELETE error: #{errorThrown}"
						# no callback called
			get: (url, callback) ->
				$.ajax url,
					dataType: "json"
					type: "GET"
					success: (data, status, XHR) ->
						console.log "AJAX data loaded"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX error: #{status}"

RSimpleCrud = 
	# static extensions
	# @ here is static
	setSaveUrl: (url) =>
		@saveUrl = url
	setDeleteUrl: (url) =>
		@deleteUrl = url
	setLoadUrl: (url) =>
		@loadUrl = url
	extended: ->
		# instance extenstions
		@include
			save: (jsonData, callback) ->
				# no @ here since saveUrl is static
				$.ajax saveUrl,
					dataType: "json"
					data: jsonData
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{jsonData} saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"
			delete: (id, callback) ->
				url = deleteUrl + "/" + id
				$.ajax url,
					#dataType: "json"
					#data: jsonData
					type: "DELETE"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{url} called succesfully"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX DELETE error: #{errorThrown}"
			get: (callback) ->
				$.ajax loadUrl,
					dataType: "json"
					type: "GET"
					success: (data, status, XHR) ->
						console.log "AJAX data loaded"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX error: #{status}"

# export to root object
root.RMoveItem = RMoveItem
root.RGroupBy = RGroupBy
root.RTeamMember = RTeamMember
root.RCrud = RCrud
root.RSimpleCrud = RSimpleCrud