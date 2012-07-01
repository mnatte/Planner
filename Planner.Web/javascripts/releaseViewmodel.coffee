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
		@hoursChartOptions = 
			chart:
				renderTo: 'chart-hours',
				type: 'column'
			title:
				text: 'Workload overview'
			xAxis: 
				categories: ['Pief', 'Paf', 'Poef']
			yAxis:
				title:
					text: 'Hours'
			tooltip:
				formatter: ->
					'<b>' + this.series.name + '</b><br/>' + this.y + ' ' + this.x.toLowerCase()

		@hoursChart = new Highcharts.Chart(@hoursChartOptions) 
		@categories = ko.observableArray(['aap', 'noot', 'mies'])

		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			@statuses.push(statusgroup.label)

		for phase in @phases() when phase.isCurrent()
			ph = new Period(@currentDate(), phase.endDate.date, "")
			phase.workingDaysRemaining = ph.workingDays()
			@currentPhases.push(phase)

		# console.log ("first phase: " + @phases()[0])
		@selectedPhaseId = ko.observable()
		@selectedPhaseId.subscribe((newValue) =>
			projHours = @hourBalance newValue
			console.log ("from subscription: " + ko.toJSON(projHours))
			projects = []
			available = []
			work = []
			balance = []
			hours = []
			for proj in projHours
				projects.push proj.projectname
				available.push proj.availableHours
				work.push proj.workload
				balance.push proj.balance

			hours.push { name: 'Available Hrs', data: available }
			hours.push { name: 'Work Remaining', data: work }
			hours.push { name: 'Balance', data: balance }
			
			console.log projects
			console.log ko.toJSON(hours)
			@hoursChartOptions.xAxis.categories = projects
			@hoursChartOptions.series = hours #[{name: 'Available Hrs', data: [1,2,3] }, { name: 'Work Remaining', data: [4,5,6] }, {name: 'Balance', data: [4,2,7] }]

			@hoursChart.destroy
			@hoursChart = new Highcharts.Chart(@hoursChartOptions)
			#options = setUpHoursChart()
			#x = new Highcharts.Chart(options)
		)
			
		# observable for selecting what to exclude from calculations
		@disgardedStatuses = ko.observableArray()
		@disgardedStatuses.subscribe((newValue) ->
			#options = setUpHoursChart()
			#x = new Highcharts.Chart(options)
		)
		@loadProjects()
		
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

	# hours balance chart
	hourBalance: (selectedPhaseId) =>
			phaseId = selectedPhaseId
			releasePhases = @release.phases
			projs = []
			balanceHours = []
			#use '+' sign to convert string to int (standard javascript)
			phase = (item for item in releasePhases when +item.id is +phaseId)[0]
			#console.log "releasePhases: " + releasePhases
			#console.log "phase: " + phase

			for proj in @release.projects
				console.log proj
				#for res in proj.resources
				#	console.log res.resource
				#	console.log ((res.resource.hoursAvailable res.assignedPeriod) * res.focusFactor)
				#	console.log res.availableHours()
				remainingHours = (feat.remainingHours for feat in proj.backlog).reduce (acc, x) -> acc + x
				console.log "remainingHours: #{remainingHours}"

				available = 0
				console.log proj.resources
				if proj.resources.length > 0
					console.log "proj.resources not empty"
					available = (res.availableHours() for res in proj.resources).reduce (acc, x) -> console.log x; acc + x
				console.log "available: #{available}"
				balanceHours.push({projectname: proj.shortName, availableHours: available, workload: remainingHours, balance: Math.round available - remainingHours})

			# TODO: use logic as described in use case UGetAvailableHoursForTeamMemberFromNow
			# for set in @release.sets when set.groupedBy == "memberProject"
				#projectHours = {}
				#console.log "memberProject: #{set.label} #{set.items.length} members"
				# console.log @selectedPhaseId()
				#set.availableHours = 0
				#for member in set.items
					# console.log member
					#console.log "#{member.initials} hours per week: #{member.hoursPerWeek}"
				#	uGetHours = new UGetAvailableHoursForTeamMemberFromNow(member, phase)
				#	set.availableHours += uGetHours.execute()
				#projectHours.project = set.label 
				#projectHours.available = Math.round set.availableHours 
				# lookup project in groupedBy project set for remaining hours
				#for projset in @projects when projset.projectname == set.label
				#	# console.log "projset: #{projset.totalHours()}"
				#	projectHours.workload = Math.round projset.totalHours()
			
				#projs.push(projectHours)
			# console.log projs

			# projectNames = []
			# remainingHours = []
			# availableHours = []
			#cats = []
			#for item in projs
				# pattern matching, works only when pattern vars have same name as properties of item
				#{project, workload, available} = item
				# projectNames.push(project)
				# remainingHours.push(workload)
				# availableHours.push(available)
				# balanceHours.push({projectname: project, availableHours: available, workload: workload, balance: Math.round available - workload})
				#cats.push project
				#@categories.push project
			# {projectNames: projectNames, remainingHours: remainingHours, availableHours: availableHours, balanceHours: balanceHours}
			console.log ("balanceHours: " + ko.toJSON(balanceHours))
			balanceHours

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