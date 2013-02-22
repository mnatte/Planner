# access (for browser)
root = global ? window

RPeriodSerialize =
	extended: ->
		@include
			toJSON: ->
				copy = ko.toJS(@) #get a clean copy
				console.log copy
				delete copy.startDate.date #remove property
				copy.startDate = @startDate.dateString
				copy.endDate = @endDate.dateString
				copy #return the copy to be serialized

RReleaseSerialize = 
	extended: ->
		@include
			toConfigurationSnapshotJson: ->
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
				console.log @
				copy = ko.toJS(@) #get a clean copy, replacing all observables with their values
				copy.projects = @projects().reduce (acc, x) ->
							acc.push x.id
							acc
						, []

				copy.milestones = []
				for ms in @milestones()
					copy.milestones.push ms.toConfigurationSnapshot()
				copy.phases = []
				for phase in @phases()
					copy.phases.push phase.toConfigurationSnapshot()
				# copy #return the copy to be serialized
				# ko.toJSON calls the toJSON method of all objects. this is done on the snapshot instance, thereby only serializing the snapshot properties
				graph = ko.toJSON(copy)
				graph # return serialized object

RProjectSerialize = 
	extended: ->
		@include
			toStatusJSON: ->
				copy = ko.toJS(@) #get a clean copy
				#console.log copy
				delete copy.title #remove property
				delete copy.shortName #remove property
				delete copy.descr #remove property
				delete copy.backlog #remove property
				delete copy.tfsIterationPath #remove property
				delete copy.tfsDevBranch
				delete copy.release
				delete copy.resources
				#console.log(copy)
				copy #return the copy to be serialized
			toConfigurationSnapshot: ->
				copy = ko.toJS(@) #get a clean copy
				#console.log copy
				delete copy.resources #remove property
				delete copy.backlog #remove property
				delete copy.workload #remove property
				#console.log(copy)
				copy #return the copy to be serialized

RPhaseSerialize =
	extended: ->
		@include
			toConfigurationSnapshot: ->
				copy = ko.toJS(@) #get a clean copy
				console.log "RPhaseSerialize"
				console.log copy
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
				copy.deliverables = @deliverables().reduce (acc, x) ->
							acc.push x.id
							acc
						, []
				#console.log copy
				copy #return the copy to be serialized

RDeliverableSerialize = 
	extended: ->
		@include
			toStatusJSON: ->
				console.log @
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
				console.log(copy)
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

RAssignmentSerialize = 
	extended: ->
		@include
			toFlatJSON: ->
				copy = ko.toJS(@) #get a clean copy
				console.log copy
				delete copy.release #remove property
				delete copy.phase #remove property
				delete copy.resource #remove property
				delete copy.project #remove property
				delete copy.assignedPeriod
				delete copy.milestone
				delete copy.deliverable
				delete copy.activity
				#console.log(@resource)
				copy.resourceId = @resource.id
				copy.phaseId =  @release.id if @release?
				copy.projectId = @project.id
				copy.startDate = @period.startDate.dateString
				copy.endDate = @period.endDate.dateString
				copy.milestoneId = @milestone.id
				copy.deliverableId = @deliverable.id
				copy.activityId = @activity.id
				#console.log(copy)
				copy #return the copy to be serialized

RResourceAssignmentSerialize = 
	extended: ->
		@include
			toFlatJSON: ->
				copy = ko.toJS(@) #get a clean copy
				#console.log copy
				delete copy.release #remove property
				delete copy.phase #remove property
				delete copy.resource #remove property
				delete copy.project #remove property
				delete copy.period
				delete copy.milestone
				delete copy.deliverable
				delete copy.activity
				#console.log(@resource)
				copy.resourceId = @resource.id
				copy.phaseId =  @release.id if @release?
				copy.projectId = @project.id
				copy.startDate = @period.startDate.dateString
				copy.endDate = @period.endDate.dateString
				copy.milestoneId = @milestone.id
				copy.deliverableId = @deliverable.id
				copy.activityId = @activity.id
				#console.log(copy)
				copy #return the copy to be serialized

#used in workload property of Project
RProjectActivityStatusSerialize = 
	extended: ->
			@include
				toJSON: ->
					copy = ko.toJS(@) #get a clean copy
					delete copy.assignedResources #remove property
					copy #return the copy to be serialized

# export to root object
root.RMilestoneSerialize = RMilestoneSerialize
root.RDeliverableSerialize = RDeliverableSerialize
root.RReleaseSerialize = RReleaseSerialize
root.RAssignmentSerialize = RAssignmentSerialize
#root.RResourceAssignmentSerialize = RResourceAssignmentSerialize
root.RPhaseSerialize = RPhaseSerialize
root.RProjectSerialize = RProjectSerialize
root.RPeriodSerialize = RPeriodSerialize
root.RProjectActivityStatusSerialize = RProjectActivityStatusSerialize




	