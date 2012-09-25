# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class PhasesViewmodel
	constructor: (allReleases) ->
		# ctor is executed in context of INSTANCE. Therfore @ refers here to CURRENT INSTANCE and attaches selectedPhase to all instances (since object IS ctor)
		@selectedPhase = ko.observable()
		@canShowDetails = ko.observable(false)
		#@centerDate = ko.observable(new Date())
		#@currentPhases = ko.observableArray()
		# centerDate minus 2 weeks
		#startDate = new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) )
		# centerDate plus 4 weeks
		#endDate =  new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) )
		#@periodToView = ko.observable(new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period"))
		Project.extend(RGroupBy)
	load: (data) ->
		# all properties besides ctor are ATTACHED to prototype. these are EXECUTED in context of INSTANCE.
		# therefore @ refers to INSTANCE here 
		@releases = []
		@displayData = []
		# console.log data
		for rel in data #when rel.overlaps(@periodToView())
			console.log rel.title + ': ' + rel.endDate.dateString
			#@currentPhases.push rel
			for ph in rel.phases #when ph.overlaps(@periodToView())
				obj = {group: rel.title, start: ph.startDate.date, end: ph.endDate.date, content: ph.title, info: ph.toString()}
				@displayData.push obj
			for ms in rel.milestones #when @periodToView().containsDate(ms.date.date)
				descr = '<ul>'
				for del in ms.deliverables
					flatten = []
					descr += '<li>' + del.title + '</li>'
					for pr in del.scope
						for work in pr.workload
							flatten.push { act: work.activity.title, hrs: work.workload }
						acts = pr.group('act', flatten)
						remainingHours = (activ.hrs for activ in acts).reduce (acc, x) -> acc + x
						console.log acts
				descr += '</ul>'
				obj = {group: rel.title, start: ms.date.date, content: ms.title + '<br /><span class="icon icon-milestone" />', info: ms.date.dateString + '<br />' + ms.description + '<br/>' + descr}
				@displayData.push obj
		#@displayData.sort((a,b)-> if a.end > b.end then 1 else if a.end < b.end then -1 else 0)
		#console.log @displayData
		@showPhases = @displayData.sort((a,b)-> if a.end > b.end then 1 else if a.end < b.end then -1 else 0)

		
	closeDetails: =>
        @canShowDetails(false)

	#nextViewPeriod: ->
		#@centerDate (new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 49)) )
		#console.log @centerDate()
		#console.log @periodToView()
		#@periodToView new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period")
		#console.log @periodToView()
		#@currentPhases.removeAll()
		#for phase in @releases when phase.overlaps(@periodToView())
			#@currentPhases.push phase

	#prevViewPeriod: ->
		#@centerDate (new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 49)) )
		#console.log @centerDate()
		#console.log @periodToView()
		#@periodToView new Period(new Date(@centerDate().getTime() - (24 * 60 * 60 * 1000 * 14) ), new Date(@centerDate().getTime() + (24 * 60 * 60 * 1000 * 28) ), "View Period")
		#console.log @periodToView()
		#@currentPhases.removeAll()
		#for phase in @releases when phase.overlaps(@periodToView())
			#@currentPhases.push phase

	selectPhase: (data) =>
		# console.log "selectPhase - function"
		# console.log @
		# console.log data
		@selectedPhase(data)
		@canShowDetails(true)
		# console.log "selectPhase after selection: " + @selectedPhase()

# export to root object
root.PhasesViewmodel = PhasesViewmodel