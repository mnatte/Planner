# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ModifyAbsencesViewmodel
	# allResources is used in the pulldown to select a resource.
	# @selectedAbsence is an observable needed here to modify, from another view, the selected absence.
	constructor: (@selectedAbsence, @allResources, @afterSubmitCallback) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		console.log 'ModifyAbsencesViewmodel instantiated'
		console.log @selectedAbsence
		#console.log @allResources
		# enable persistence of instances of Period (absences)
		Period.extend RCrud
		Period.extend RPeriodSerialize
		Resource.extend RTeamMember

		if @selectedAbsence().person
			@selectedPerson = p for p in @allResources when p.id is @selectedAbsence().person.id
			console.log @selectedPerson

		# @selectedResource is relevant within this context; not in the parent context
		@selectedResource = ko.observable(@selectedPerson)


	saveSelectedAbsence: =>
		absence = @selectedAbsence() # set object to persist
		if @selectedAbsence().id > 0 # update of existing absence, set personId
			absence.personId = absence.person.id
			delete absence.person
		else
			absence.personId = @selectedResource().id
		console.log ko.toJSON(absence)
		@selectedAbsence().save("/planner/Resource/SaveAbsence", ko.toJSON(absence), @afterSubmitCallback)

	deleteSelectedAbsence: =>
		console.log @selectedAbsence()
		@selectedAbsence().delete("/planner/Resource/DeleteAbsence/" + @selectedAbsence().id, @afterSubmitCallback)

# export to root object
root.ModifyAbsencesViewmodel = ModifyAbsencesViewmodel