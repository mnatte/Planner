# access (for browser)
root = global ? window
# define namespace
root.Mnd or={}

class Mnd.Timeline
	#ctor with default values, overridden when given
	constructor: (@data, @observableSelected, @width = "100%", @height = "800px", @divName ="mytimeline", @detailsDiv= "details") ->
		#specify options
		@options = {
			"width": @width,
			"height": @height,
			"style": "box",
			"eventMargin": 5, # minimal margin between events 
			"intervalMin": 1000 * 60 * 60 * 24,          # one day in milliseconds
			"intervalMax": 1000 * 60 * 60 * 24 * 31 * 3,  # about three months in milliseconds
			"editable": false
		}
		# Instantiate our timeline object.
		@timeline = new links.Timeline(document.getElementById(@divName))
		# attach an event listener using the links events handler
		links.events.addListener(@timeline, 'select', @onSelectedChanged)
		#links.events.addListener(@timeline, 'change', @onChange)
	draw: ->
	    # Draw our timeline with the created data and options 
		@timeline.draw(@data, @options)
	onSelectedChanged: (properties)  =>
        details = document.getElementById(@detailsDiv)
        $(details).html('')
        sel = @timeline.getSelection()
        #console.log 'selection:'
        #console.log sel
        if sel.length
            #console.log sel[0]
            if sel[0] isnt undefined 
                item = @data[sel[0].row]
                if typeof item.info isnt "undefined"
                    $(details).html(item.info)
                if typeof @observableSelected isnt "undefined"
                    @observableSelected(item)
	#onChange: =>
		#sel = @timeline.getSelection()
		#if sel.length
			#console.log sel[0]
			#if sel[0] isnt undefined 
				#item = @data[sel[0].row]
				#console.log item

root.Mnd.Timeline = Mnd.Timeline