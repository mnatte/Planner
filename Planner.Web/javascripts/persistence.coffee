# access (for browser)
root = global ? window

RReleaseSerialize = 
	extended: ->
		@include
			toConfigurationSnapshot: ->
				# serialized graph:
				#{"id":130,"startDate":"06/10/2012","endDate":"06/10/2012","title":"Test","tfsIterationPath":""
				#	,"phases":[
				#		{"id":130,"startDate":"07/10/2012","endDate":"07/10/2012","title":"Phase 1","tfsIterationPath":"","parentId":130}
				#	]
				#	,"projects":[
				#		{"id":1,"title":"EU Maintenance","shortName":"EU","descr":"","tfsIterationPath":"","tfsDevBranch":"Dev-5"}
				#		,{"id":2,"title":"APAC","shortName":"APAC","descr":"","tfsIterationPath":"NLBEESD-VFS-PM\\Release 9.2\\APAC","tfsDevBranch":"Dev-2"}
				#	]
				#	,"milestones":[
				#		{"id":35,"time":"0:00","title":"New Milestone","description":"","phaseId":130,"date":"07/10/2012"
				#			,"deliverables":[
				#				1,2
				#			]
				#		}
				#	]
				#}

				#console.log 'serialize release configuration'
				#console.log @
				copy = ko.toJS(@) #get a clean copy
				copy.projects = @projects.reduce (acc, x) ->
							acc.push x.id
							acc
						, []
				#copy.projects = []
				#for proj in @projects
					#console.log proj.toConfigurationSnapshot()
				#	copy.projects.push proj.toConfigurationSnapshot()
				copy.milestones = []
				for ms in @milestones
					copy.milestones.push ms.toConfigurationSnapshot()
				copy.phases = []
				for phase in @phases
					copy.phases.push phase.toConfigurationSnapshot()
				copy #return the copy to be serialized


RMilestoneSerialize = 
	extended: ->
		@include
			toJSON: ->
				#console.log 'doing toJSON in milestone'
				copy = ko.toJS(@) #get a clean copy
				delete copy.date.date #remove property
				copy.date = @date.dateString
				copy #return the copy to be serialized
			toConfigurationSnapshot: ->
				#console.log @
				copy = ko.toJS(@) #get a clean copy
				#delete copy.date #remove property
				#copy.date = @date.dateString
				copy.deliverables = @deliverables.reduce (acc, x) ->
							acc.push x.id
							acc
						, []
				#console.log copy
				copy #return the copy to be serialized

RDeliverableSerialize = 
	extended: ->
		@include
			toStatusJSON: ->
				copy = ko.toJS(@) #get a clean copy
				#console.log copy
				delete copy.title #remove property
				delete copy.description #remove property
				delete copy.format #remove property
				delete copy.location #remove property
				delete copy.activities
				delete copy.milestone
				copy.releaseId = @milestone.phaseId
				copy.milestoneId = @milestone.id
				copy.deliverableId = @id
				copy.scope = []
				for proj in @scope
					copy.scope.push proj.toStatusJSON()
				#console.log(copy)
				copy #return the copy to be serialized
			toConfigurationSnapshot: ->
				copy = ko.toJS(@) #get a clean copy
				delete copy.title #remove property
				delete copy.description #remove property
				delete copy.format #remove property
				delete copy.location #remove property
				delete copy.activities
				delete copy.scope
				delete copy.milestone
				copy

# export to root object
root.RMilestoneSerialize = RMilestoneSerialize
root.RDeliverableSerialize = RDeliverableSerialize
root.RReleaseSerialize = RReleaseSerialize

	