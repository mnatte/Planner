# access (for browser)
root = global ? window

class releaseViewmodel
	constructor ->
		# load from model: Release

	# release overview info
	releasetitle
	releaseStartdate
	releaseEnddate
	releaseWorkingDays
	releaseWorkingDaysRemaining
	currentDate
	phases[]
		title
		startDate
		endDate

	# tabs per project
	disgardedStatuses # observable for selecting what to exclude from calculations
	projectShortname[]
		features[]
			businessId
            title
            remainingHours
            contactPerson
            state
		totalRemaining (computed observable)
		
	# pie chart, count by status (x under dev, y ready for system test, etc.)
	# format: [ ["Ready For Dev", 2], ["Ready For Test", 3] ]
	statusData = []
		for statusgroup in @release.sets when statusgroup.groupedBy == "state"
			data = []
			data.push(statusgroup.label)
			data.push(statusgroup.items.length)
			statusData.push(data)

	# hours per project chart
	projectShortNames
	availableHours
	remainingHours
	balanceHours



# export to root object
root.releaseViewmodel = releaseViewmodel