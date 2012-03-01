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

# export to root object
root.RMoveItem = RMoveItem