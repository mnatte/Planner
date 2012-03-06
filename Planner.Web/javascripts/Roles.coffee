# access (for browser)
root = global ? window

RMoveItem = 
	move: (source, target) ->
		# remove item from source
		source.splice(source.indexOf((@)), 1);
		# assign item to target
		target.push(@)
	extended: ->
		@include
			test: "extended with RMoveItem"

RGroupBy = 
	extended: ->
		@include
			sets: []
			group: (property, collection) ->
				# algorithm:
				# 1) create set per propertyValue
				#		i) create set of sets property
				#		ii) iterate over collection
					for item in collection when @sets[item[property]] is undefined
				#		iii) add set (with set name) to set collection when set with name propertyValue does not exits
					 # unless item[property] in @sets
						console.log("add set with propertyValue: " + item[property])
						@sets[item[property]] = {}
						# @sets[item[property]].name = item[property]
						# @sets[item[property]].items = []
						# console.log("set[#{item[property]}] is " + @sets[item[property]].name)
						@sets.push(name: item[property], items: [], link: "#"+item[property])
				# 2) add item to set when property == propertyValue
				#		i) iterate over sets
				#		ii) add item to setitem when propertyValue == setName
		

# export to root object
root.RMoveItem = RMoveItem
root.RGroupBy = RGroupBy