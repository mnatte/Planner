# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

# TODO 20120514: ADD PROJECT OBJECT AND COMPLETE PROJECTVIEWMODEL WITH CRUD SERVICE METHODS

class AdminProjectViewmodel
	constructor: (allProjects) ->
		Project.extend(RCrud)
		@selectedProject = ko.observable()
		@allProjects = ko.observableArray(allProjects)
		@allProjects.sort()
		# setup nice 'remove' method for Array
		Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

	selectProject: (data) =>
		console.log "selectProject - function"
		# console.log @
		# console.log data
		@selectedProject data
		#console.log "selectRelease after selection: " + @selectedRelease().title + ", parentId: " +  @selectedRelease().parentId

	refreshProject: (index, jsonData) =>
		# use given index or take new index ('length' is one larger than max index) when item is not in @allReleases (value is -1). 
		# when not in @allReleases, the item is new and will be inserted at the end. no item will be removed prior to adding it.
		i = if index >= 0 then index else @allProjects().length
		# console.log "index: #{index}"
		# console.log "i: #{i}"
		
		# i = index of item to remove, 1 is amount to be removed
		@allProjects.splice(i,1)
		# insert newly loaded release when available
		console.log jsonData
		if jsonData != null and jsonData != undefined
			console.log "jsonData not undefined"
			proj = new Project(jsonData.Id, jsonData.Title, jsonData.ShortName, jsonData.Description, jsonData.TfsIterationPath, jsonData.TfsDevBranch)
			@allProjects.splice i, 0, proj
		else
			@selectProject @allProjects()[0]

	clear: ->
		console.log "clear: selectedProject: #{@selectedProject().title}"
		@selectProject new Project(0, "", "", "", "", "")

	addProject: (data) =>
		@selectProject new Project(0, "", "", "", "", "", data.id)

	saveSelected: =>
		console.log "saveSelected: selectedProject: #{@selectedProject()}"
		console.log ko.toJSON(@selectedProject())
		proj = (a for a in @allProjects() when a.id is @selectedProject().id)[0]
		i = @allProjects().indexOf(proj)
		@selectedProject().save("/planner/Project/Save", ko.toJSON(@selectedProject()), (data) => @refreshProject(i, data))
	
	deleteProject: (data) =>
		proj = (a for a in @allProjects() when a.id is data.id)[0]
		id = data.id
		# use index for removing from @allReleases
		i = @allProjects().indexOf(proj)

		proj.delete("/planner/Project/Delete/" + proj.id, (callbackdata) =>
			console.log callbackdata
			@refreshProject(i)
			#proj.get("/planner/Project/GetProjectById/"+ id, (jsonData) => @refreshProject(i, jsonData))
		)
		
# export to root object
root.AdminProjectViewmodel = AdminProjectViewmodel