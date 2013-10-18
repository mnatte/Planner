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
			getPlanning: (period) ->
				absences = (abs for abs in @periodsAway when abs.overlaps(period))
				assignments = (ass for ass in @assignments when ass.period.overlaps(period))
				{absences: absences, assignments: assignments}
			getPlannedHoursPerAssignmentIncludingAbsences: (period) ->
				planning = @getPlanning period
				overview = []
				if(planning.assignments? and typeof(planning.assignments) isnt 'undefined' and planning.assignments.length > 0)
					overview = (assignment for assignment in planning.assignments).reduce (acc, x) ->
							#per = x.period.overlappingPeriod(period)
							console.log assignment
							dys = x.period.overlappingPeriod(period).workingDays()
							hrs = Math.round(dys * 8 * x.focusFactor)
							acc.push {days: dys, hours: hrs, assignment: x.activity.title + ' ' + x.deliverable.title + ' ' + x.focusFactor * 100 + '%'}
							acc
						, []
				overview.push {days: @daysAbsent(period), hours: @hoursAbsent(period), assignment: 'Absent'}
				console.log overview
				overview
			hoursPlannedIn: (period) ->
				# this is based on the remaining working days of the period, therefore it discards the past dates within the period giving an accurate view.
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
				# this is based on the remaining working days of the period, therefore it discards the past dates within the period giving an accurate view.
				absent = 0
				# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
				overlappingAbsences = (absence for absence in @periodsAway when absence.overlaps(period))
				if(overlappingAbsences? and typeof(overlappingAbsences) isnt 'undefined' and overlappingAbsences.length > 0)
					absent = (absence.overlappingPeriod(period) for absence in overlappingAbsences).reduce (acc, x) ->
							result = x.remainingWorkingDays()
							acc + result
						, 0
				Math.round(absent * 8)
			daysAbsent: (period) ->
				# this is based on the remaining working days of the period, therefore it discards the past dates within the period giving an accurate view.
				absent = 0
				# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
				overlappingAbsences = (absence for absence in @periodsAway when absence.overlaps(period))
				if(overlappingAbsences? and typeof(overlappingAbsences) isnt 'undefined' and overlappingAbsences.length > 0)
					absent = (absence.overlappingPeriod(period) for absence in overlappingAbsences).reduce (acc, x) ->
							result = x.remainingWorkingDays()
							acc + result
						, 0
				Math.round(absent)
			hoursAvailable: (period) ->
				# this is based on the remaining working days of the period, therefore it discards the past dates within the period giving an accurate view.
				absent = 0
				# ESSENTIAL: add parentheses around for...when, otherwise no array is returned
				overlappingAbsences = (absence for absence in @periodsAway when absence.overlaps(period))
				# somehow "reduce (x,y)" needs a space between name ('reduce') and args
				if(overlappingAbsences? and typeof(overlappingAbsences) isnt 'undefined' and overlappingAbsences.length > 0)
					absent = (absence.overlappingPeriod(period) for absence in overlappingAbsences).reduce (acc, x) ->
							console.log "RTeamMember hoursAvailable"
							console.log x
							console.log x.remainingWorkingDays()
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
			getOverplannedPeriods: (period) ->
				console.log @fullName()
				overplannedPeriods = []
				assignedPeriods = (ass for ass in @assignments when ass.period.overlaps(period)).reduce (acc, x) ->
					console.log 'nieuwe assignment: ' + x.period
					# immediately put assignment as overplanned, no merging with accumulated period needed
					if x.focusFactor > 0.8
						console.log 'focusFactor > 0.8'
						overplannedPeriods.push x
						# just return current accumulation
					else if x.period.overlaps(acc.period)
						newFocusFactor = acc.focusFactor + x.focusFactor
						console.log 'period overlaps; newFocusFactor: ' + newFocusFactor
						if newFocusFactor > 0.8
							console.log 'newFocusFactor > 0.8 '
							overplannedPeriods.push x
							# just return current accumulation
						else
							overlap = { period: acc.period.overlappingPeriod(x.period), focusFactor: newFocusFactor }
							console.log 'new acc: ' + overlap.period
							# set acc to overlap period with accumulated focusFactor
							acc = overlap
					else
						#console.log 'period NOT overlaps'
						acc = { period: x.period, focusFactor: x.focusFactor }
					console.log 'accumulator period value: ' + acc.period
					acc
				, {period: period, focusFactor: 0}
				#console.log overplannedPeriods
				overplannedPeriods
			hasOverplannedPeriods: (period) ->
				ret = @getOverplannedPeriods(period).length > 0
				#console.log ret
				ret
			plan: (rel, proj, ms, del, act, per, ff, callback) ->
				$.ajax "/planner/Resource/Plan",
					dataType: "json"
					data: ko.toJSON({ phaseId: rel.id, projectId: proj.id, milestoneId: ms.id, deliverableId: del.id, activityId: act.id, startDate: per.startDate.dateString, endDate: per.endDate.dateString, focusFactor: ff, resourceId: @id })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "planned resource saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"
			unassign: (rel, proj, ms, del, act, per, callback) ->
				$.ajax "/planner/Resource/UnAssign",
					dataType: "json"
					data: ko.toJSON({ phaseId: rel.id, projectId: proj.id, milestoneId: ms.id, deliverableId: del.id, activityId: act.id, startDate: per.startDate.dateString, endDate: per.endDate.dateString, resourceId: @id })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "resource unassigned"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"
			planForRelease: (rel, proj, ms, del, act, per, ff, callback) ->
				$.ajax "/planner/Resource/Release/Plan",
					dataType: "json"
					data: ko.toJSON({ phaseId: rel.id, projectId: proj.id, milestoneId: ms.id, deliverableId: del.id, activityId: act.id, startDate: per.startDate.dateString, endDate: per.endDate.dateString, focusFactor: ff, resourceId: @id })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "planned resource saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"
			unassignFromRelease: (rel, proj, ms, del, act, per, callback) ->
				$.ajax "/planner/Resource/Release/UnAssign",
					dataType: "json"
					data: ko.toJSON({ phaseId: rel.id, projectId: proj.id, milestoneId: ms.id, deliverableId: del.id, activityId: act.id, startDate: per.startDate.dateString, endDate: per.endDate.dateString, resourceId: @id })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "resource unassigned"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"

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


RScheduleItem = 
	# static extensions
	# @ here is static
	setScheduleUrl: (url) =>
		@scheduleUrl = url
	extended: ->
		# instance extensions
		@include
			schedule: (itemId, relId, dateString, timeString, callback) ->
				# no @ here since scheduleUrl is static
				$.ajax scheduleUrl,
					dataType: "json"
					data: ko.toJSON({ time: timeString, date: dateString, releaseId: relId, eventId: itemId })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{data} saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"

RSchedulePeriod = 
	# static extensions
	# @ here is static
	setScheduleUrl: (url) =>
		@scheduleUrl = url
	extended: ->
		# instance extensions
		@include
			schedule: (periodId, relId, startDateString, endDateString, callback) ->
				# no @ here since scheduleUrl is static
				$.ajax scheduleUrl,
					dataType: "json"
					data: ko.toJSON({ startDate: startDateString, endDate: endDateString, releaseId: relId, eventId: periodId })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{data} saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"

RPlanEnvironment = 
	# static extensions
	# @ here is static
	setPlanUrl: (url) =>
		@planUrl = url
	setUnAssignUrl: (url) =>
		@unAssignUrl = url
	extended: ->
		# instance extensions
		@include
			plan: (version, period, callback) ->
				# no @ here since setUrl is static
				console.log period.title
				$.ajax planUrl,
					dataType: "json"
					data: ko.toJSON({ purpose: period.title, startDate: period.startDate.dateString, endDate: period.endDate.dateString, phaseId: period.id, version: version, environment: @ })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{data} saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"
			unplan: (version, period, callback) ->
				# no @ here since setUrl is static
				console.log period
				$.ajax unAssignUrl,
					dataType: "json"
					data: ko.toJSON({ phaseId: period.id, version: version, environment: @ })
					type: "POST"
					contentType: "application/json; charset=utf-8"
					success: (data, status, XHR) ->
						console.log "#{data} saved"
						callback data
					error: (XHR, status, errorThrown) ->
						console.log "AJAX SAVE error: #{errorThrown}"

RDeliverableStatus = 
	extended: ->
		@include
			isUnderPlanned: ->
				underplanned = false
				for proj in @scope
					activities = proj.workload.reduce (acc, x) ->
								acc.push {activityTitle :x.activity.title, hrs: x.hoursRemaining, planned: x.assignedResources.reduce ((acc, x) -> acc + x.resourceAvailableHours()), 0 }
								acc
							, []
					for act in activities
						underplanned = act.hrs > act.planned
				underplanned
			plannedHours: ->
				hours = 0
				for proj in @scope
					activities = proj.workload.reduce (acc, x) ->
								acc.push {activityTitle :x.activity.title, hrs: x.hoursRemaining, planned: x.assignedResources.reduce ((acc, x) -> acc + x.resourceAvailableHours()), 0 }
								acc
							, []
					hours += activities.reduce (acc, x) ->
							acc + x.planned
						, 0
				hours
				

# export to root object
root.RMoveItem = RMoveItem
root.RGroupBy = RGroupBy
root.RTeamMember = RTeamMember
root.RCrud = RCrud
root.RSimpleCrud = RSimpleCrud
root.RScheduleItem = RScheduleItem
root.RSchedulePeriod = RSchedulePeriod
root.RDeliverableStatus = RDeliverableStatus
root.RPlanEnvironment = RPlanEnvironment

