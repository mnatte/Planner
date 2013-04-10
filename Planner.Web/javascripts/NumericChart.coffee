# access (for browser)
root = global ? window
# define namespace
root.Mnd or={}

#depends on Highcharts.js
class Mnd.NumericChart
	#ctor with default values, overridden when given
	constructor: (@divName, @title, @subtitle = null) ->
		#specify options
		@options = 
			chart:
				renderTo: @divName
			title:
				text: @title
			subtitle:
				text: @subtitle
			xAxis: 
				labels:
					align: 'left',
					x: 3,
					y: -3
			yAxis:[{ # left y axis
                    title:
                        text: null
                    labels:
                        align: 'left',
                        x: 3,
                        y: 16,
                        formatter: -> 
                            Highcharts.numberFormat(@value, 0)                     
                    showFirstLabel: false
         }, { # right y axis
                    linkedTo: 0,
                    gridLineWidth: 0,
                    opposite: true,
                    title:
                        text: null
                   labels:
                        align: 'right',
                        x: -3,
                        y: 16,
                        formatter: ->
                            Highcharts.numberFormat(@value, 0)
                    showFirstLabel: false
                }],
			legend:
                    align: 'left',
                    verticalAlign: 'top',
                    y: 20,
                    floating: true,
                    borderWidth: 0
                tooltip:
                    shared: true,
                    crosshairs: true
                plotOptions:
                    series:
                       cursor: 'pointer',
                       point:
                           events:
                               click: ->
                                   hs.htmlExpand(null, {
                                       pageOrigin: {
                                           x: this.pageX,
                                           y: this.pageY
                                       },
                                       headingText: this.series.name,
                                       maincontentText: 'day number ' + this.x + ':<br/> ' +
                                       this.y + ' hours',
                                       width: 200
                                   });
                        marker:
                            lineWidth: 1
                series: []
	draw: ->
	    # Draw our timeline with the created data and options 
		chart = new Highcharts.Chart(@options)
	addLineName: (linename)  =>
		@options.series.push({ name: linename })
	addLineData: (index, data)  =>
		@options.series[index].data = data
        

root.Mnd.NumericChart = Mnd.NumericChart