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
					# remember what sets we have created based on groupby property
					addedSets = []
					# iterate over collection
					for item in collection
						# add set (with label) to set collection when no set with label propertyValue exists
						unless item[property] in addedSets
							# console.log("add set with propertyValue: " + item[property])
							# set has a label, a collection and a link property. link can be used to link to it in UI for tabs for example
							@sets.push(label: item[property], items: [])
							addedSets.push(item[property])
						# add item to set when property == propertyValue
						set = (grp for grp in @sets when grp.label == item[property])[0]
						# console.log("set: #{set}")
						set.items.push(item)
						# console.log("added #{item} to set #{set.name}")

# export to root object
root.RMoveItem = RMoveItem
root.RGroupBy = RGroupBy