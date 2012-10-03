# require release.js
# require knockout 2.0.0.js

# access (for browser)
root = global ? window

class SimpleCrudViewmodel
	constructor: (allItems) ->
		@selectedItem = ko.observable()
		@allItems = ko.observableArray(allItems)
		@allItems.sort()
		# setup nice 'remove' method for Array
		Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

	selectItem: (data) =>
		@selectedItem data

	createNewItem: (jsonData) =>
		throw new Error('Abstract method createNewItem')

	createNewEmptyItem: =>
		throw new Error('Abstract method createNewEmptyItem')

	refreshItem: (index, jsonData) =>
		# use given index or take new index ('length' is one larger than max index) when item is not in @allReleases (value is -1). 
		# when not in @allReleases, the item is new and will be inserted at the end. no item will be removed prior to adding it.
		i = if index >= 0 then index else @allItems().length
		
		# i = index of item to remove, 1 is amount to be removed
		@allItems.splice(i,1)
		# insert newly loaded release when available
		if jsonData != null and jsonData != undefined
			item = @createNewItem(jsonData)
			@allItems.splice i, 0, item
		else
			@selectItem @allItems()[0]

	clear: ->
		@selectItem @createNewEmptyItem() # () are needed here, maybe because of inheritance or something?

	saveSelected: =>
		# console.log ko.toJSON(@selectedItem())
		item = (a for a in @allItems() when a.id is @selectedItem().id)[0]
		i = @allItems().indexOf(item)
		
		@selectedItem().save(ko.toJSON(@selectedItem()), (data) => @refreshItem(i, data))
	
	deleteItem: (data, callback) =>
		item = (a for a in @allItems() when a.id is data.id)[0]
		id = data.id
		# use index for removing from @allItems
		i = @allItems().indexOf(item)

		item.delete(item.id, (callbackdata) =>
			# console.log callbackdata
			@refreshItem(i)
			callback
		)
		
# export to root object
root.SimpleCrudViewmodel = SimpleCrudViewmodel