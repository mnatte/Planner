(function () {
    ko.bindingHandlers.period = {
        init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
            // valueAccessor is viewPeriod, viewModel is phase to determine width and offset for
            console.log("viewModel (phase): " + viewModel.toString());
            console.log("valueAccessor (periodToView): " + valueAccessor());
            // TODO: set filter in HTML page already
            if (!viewModel.overlaps(valueAccessor())) {
                $(element).remove();
            } else {
                // get overlapping period
                var overlap = viewModel.overlappingPeriod(valueAccessor());
                console.log(overlap.toString());
                console.log("overlapping days: " + overlap.days());
                console.log("overlapping working days: " + overlap.workingDays());
                // view period is 7 weeks. this is 49 days; we can have 2% per day to come to 98% of the view period's space.
                var width = (overlap.days() * 2) + "%";
                console.log("width: " + width);

                var left;
                var offset = new Period(valueAccessor().startDate.date, viewModel.startDate.date);
                console.log(offset.toString());
                if (offset.days() <= 0) {
                    left = "1%";
                } else {
                    left = (offset.days() * 2) + "%";
                }
                console.log("offset: " + left);
                $(element).css("width", width)
                    .css("left", left)
                    .tooltip({
                        delay: 1,
                        showUrl: false,
                        fade: 250,
                        track: true,
                        fixPNG: true,
                        extraClass: "pretty fancy",
                        top: -15,
                        left: 5,
                        bodyHandler: function () {
                            return viewModel.title + ", " + viewModel.startDate.dateString + " - " + viewModel.endDate.dateString + ". " + viewModel.workingDaysRemaining() + " working days remaining";
                        }
                });
            }
        }
    };
})();