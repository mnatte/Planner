# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ModifyAssignmentsViewmodel
	# allResources is used in the pulldown to select a resource.
	# @selectedAssignment is an observable needed here to modify, from another view, the selected assignment.
	constructor: (@selectedAssignment, @allResources, @afterSubmitCallback) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		console.log 'ModifyAssignmentsViewmodel instantiated'
		console.log @selectedAssignment()
		#console.log @allResources
		# enable persistence of instances of Period (absences)
		Period.extend RCrud
		Period.extend RPeriodSerialize
		Resource.extend RTeamMember

		if @selectedAssignment().resource
			@selectedPerson = p for p in @allResources when p.id is @selectedAssignment().resource.id
			console.log @selectedPerson

		# @selectedResource is relevant within this context; not in the parent context
		@selectedResource = ko.observable(@selectedPerson)


	saveSelectedAssignment: =>
		console.log 'saveSelectedAssignment'
		assignment = @selectedAssignment() # set object to persist
		#if @selectedAssignment().id > 0 # update of existing absence, set personId
		#	assignment.personId = assignment.person.id
		#	delete assignment.person
		#else
		#	assignment.personId = @selectedResource().id
		console.log ko.toJSON(assignment)
		#@afterSubmitCallback()
		#@selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(absence), @afterSubmitCallback)
		@selectedAssignment().resource.plan(assignment.release, assignment.project, assignment.milestone, assignment.deliverable, assignment.activity, assignment.period, assignment.focusFactor, @afterSubmitCallback)

	deleteSelectedAssignment: =>
		console.log @selectedAssignment()
		#@selectedAbsence().delete("/planner/Resource/DeleteAbsence/" + @selectedAbsence().id, @afterSubmitCallback)

# export to root object
root.ModifyAssignmentsViewmodel = ModifyAssignmentsViewmodel