# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class ReleaseViewmodel
	constructor: (@release) ->
		# create Phase from now till end of release
		@fromNowTillEnd = new Period(new Date(), @release.endDate.date, "from now till end")
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
				categories: []
			yAxis:
				title:
					text: 'Hours'
			tooltip:
				formatter: ->
					'<b>' + this.series.name + '</b><br/>' + this.y + ' ' + this.x.toLowerCase()

		@hoursChart = new Highcharts.Chart(@hoursChartOptions) 

		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			@statuses.push(statusgroup.label)

		for phase in @release.phases when phase.isCurrent()
			ph = new Period(@currentDate(), phase.endDate.date, "")
			phase.workingDaysFromNow = ph.workingDays()
			@currentPhases.push(phase)

		@selectedPhaseId = ko.observable()
		@selectedPhaseId.subscribe((newValue) =>
			console.log newValue
			@redrawChart newValue
		)
			
		# observable for selecting what to exclude from calculations
		@disgardedStatuses = ko.observableArray()
		@disgardedStatuses.subscribe((newValue) =>
			@redrawChart @selectedPhaseId
		)
		@loadProjects()
		
	# release overview info
	#releaseTitle: -> @release.title
	#releaseStartdate: -> @release.startDate.date
	#releaseEnddate: -> @release.endDate.date
	releaseWorkingDays: -> @release.workingDays()
	currentDate: -> new Date()
	#phases: -> @release.phases
			
	releaseWorkingDaysRemaining: -> @fromNowTillEnd.workingDays()

	redrawChart: (phaseId) ->
		projHours = @hourBalance phaseId
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
			
		@hoursChartOptions.xAxis.categories = projects
		# format: [{name: 'Available Hrs', data: [1,2,3] }, { name: 'Work Remaining', data: [4,5,6] }, {name: 'Balance', data: [4,2,7] }]
		@hoursChartOptions.series = hours
		@hoursChart.destroy
		@hoursChart = new Highcharts.Chart(@hoursChartOptions)
	
	# projects: -> $.grep(@release.sets, (n,I) -> n.groupedBy == 'project') #jQuery syntax
	loadProjects: =>
		for project in @release.projects
			proj = {}
			proj.projectname = project.shortName
			proj.link = "#" + project.shortName
			proj.backlog = project.backlog
			# 'do' generates a closure: the proj param is added to a wrapping function containing the function itself as well as the param from this context.
			# the '=>' fat arrow references the 'this' context stored in the generated '_this' variable so it always references the viewmodel instance
			# since the totalHours item is added as a property of the proj item it is added to an observable array
			proj.totalHours = do (proj) => ko.computed( => t = 0; $.each(proj.backlog, (n,l) => t += l.remainingHours unless (l.state in @disgardedStatuses())); t)
			@projects.push(proj)

	# hours balance chart; return array of {projectname, availableHours, workload, balance} objects
	hourBalance: (selectedPhaseId) =>
			phaseId = selectedPhaseId
			releasePhases = @release.phases
			projs = []
			balanceHours = []
			#use '+' sign to convert string to int (standard javascript)
			phase = (item for item in releasePhases when +item.id is +phaseId)[0]

			for proj in @release.projects
				remainingHours = (feat.remainingHours for feat in proj.backlog when (feat.state not in @disgardedStatuses())).reduce (acc, x) -> acc + x
				
				available = 0
				if proj.resources.length > 0
					available = (res.availableHours() for res in proj.resources).reduce (acc, x) -> acc + x
				
				balanceHours.push({projectname: proj.shortName, availableHours: available, workload: remainingHours, balance: Math.round available - remainingHours})

			# console.log ("balanceHours: " + ko.toJSON(balanceHours))
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