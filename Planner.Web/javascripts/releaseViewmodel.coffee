# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseViewmodel
	constructor: (@release) ->
		# create Phase from now till end of release
		@fromNowTillEnd = new Period(new Date(), @release.endDate.date, "from now till end")
		# console.log "releaseViewmodel for release #{@release.title}"
		@projects = []
		@statuses = []
		@currentPhases = []

		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			@statuses.push(statusgroup.label)

		for phase in @phases() when phase.isCurrent()
			ph = new Period(@currentDate(), phase.endDate.date, "")
			phase.workingDaysRemaining = ph.workingDays()
			@currentPhases.push(phase)

		# console.log ("first phase: " + @phases()[0])
		phaseId = @phases()[0].id
		@selectedPhaseId = ko.observable(phaseId)
			
		# observable for selecting what to exclude from calculations
		@disgardedStatuses = ko.observableArray()
		@loadProjects()
		
		@displaySelected = ko.computed(=> 
				console.log @
				console.log @disgardedStatuses()
				showTableChart()
				s = ""
				s += "#{item} - " for item in @disgardedStatuses()
				s 
			, this)

		@displaySelectedPhaseId = ko.computed(=> 
			console.log @
			console.log @selectedPhaseId()
		, this)

		# hours balance chart
		@hourBalance = ko.computed( => 
				#console.log @
				#console.log @selectedPhaseId()
				phaseId = @selectedPhaseId()
				releasePhases = @release.phases
				projs = []
				#use '+' sign to convert string to int (standard javascript)
				phase = (item for item in releasePhases when item.id is +phaseId)[0]
				console.log phase
				for set in @release.sets when set.groupedBy == "memberProject"
					projectHours = {}
					#console.log "memberProject: #{set.label} #{set.items.length} members"
					# get development phase TODO: select from UI
					# console.log @selectedPhaseId()
					set.availableHours = 0
					for member in set.items
						# console.log member
						#console.log "#{member.initials} hours per week: #{member.hoursPerWeek}"
						uGetHours = new UGetAvailableHoursForTeamMemberFromNow(member, phase)
						set.availableHours += uGetHours.execute()
					projectHours.project = set.label 
					projectHours.available = Math.round set.availableHours 
					# lookup project in groupedBy project set for remaining hours
					for projset in @projects when projset.projectname == set.label
						# console.log "projset: #{projset.totalHours()}"
						projectHours.workload = Math.round projset.totalHours()
			
					projs.push(projectHours)
				# console.log projs

				# projectNames = []
				# remainingHours = []
				# availableHours = []
				balanceHours = []
				for item in projs
					# pattern matching, works only when pattern vars have same name as properties of item
					{project, workload, available} = item
					# projectNames.push(project)
					# remainingHours.push(workload)
					# availableHours.push(available)
					balanceHours.push({projectname: project, availableHours: available, workload: workload, balance: Math.round available - workload})
				# {projectNames: projectNames, remainingHours: remainingHours, availableHours: availableHours, balanceHours: balanceHours}
				#console.log ("balanceHours: " + balanceHours)
				balanceHours
			, this)

	# release overview info
	releaseTitle: -> @release.title
	releaseStartdate: -> @release.startDate.date
	releaseEnddate: -> @release.endDate.date
	releaseWorkingDays: -> @release.workingDays()
	currentDate: -> new Date()
	phases: -> @release.phases
			
	releaseWorkingDaysRemaining: -> @fromNowTillEnd.workingDays()
	
	# projects: -> $.grep(@release.sets, (n,I) -> n.groupedBy == 'project') #jQuery syntax
	loadProjects: =>
		for set in @release.sets when set.groupedBy == "project"
			proj = set
			# console.log set.label
			proj.projectname = set.label
			proj.link = "#" + set.label
			# 'do' generates a closure: the proj param is added to a wrapping function containing the function itself as well as the param from this context.
			# the '=>' fat arrow references the 'this' context stored in the generated '_this' variable so it always references the viewmodel instance
			proj.totalHours = do (proj) => ko.computed( => t = 0; $.each(proj.items, (n,l) => t += l.remainingHours unless (l.state in @disgardedStatuses())); t)
			# console.log "end loadProjects()"
			@projects.push(proj)

	# pie chart, count by status (x under dev, y ready for system test, etc.)
	# format: [ ["Ready For Dev", 2], ["Ready For Test", 3] ]
	statusData: ->
		status = []
		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			data = []
			data.push(statusgroup.label)
			data.push(statusgroup.items.length)
			status.push(data)
		status

	

# export to root object
root.ReleaseViewmodel = ReleaseViewmodel