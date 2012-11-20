(function () {
    ko.bindingHandlers.period2 = {
        init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).slider({
                range: true,
                min: 0,
                max: 120,
                disabled: true,
                values: [viewModel.startDaysFromNow(), viewModel.remainingDays()]
            }).tooltip({
                delay: 1,
                showUrl: false,
                fade: 250,
                track: true,
                fixPNG: true,
                extraClass: "pretty fancy",
                top: -15,
                left: 5,
                bodyHandler: function () {
                    return viewModel.title + ", " + viewModel.startDate.dateString + " - " + viewModel.endDate.dateString + ". " + viewModel.workingDaysFromNow() + " working days remaining";
                }
            });
        },

        update: function (element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).slider({
                range: true,
                min: 0,
                max: 120,
                disabled: true,
                values: [viewModel.startDaysFromNow(), viewModel.remainingDays()]
            }).tooltip({
                delay: 1,
                showUrl: false,
                fade: 250,
                track: true,
                fixPNG: true,
                extraClass: "pretty fancy",
                top: -15,
                left: 5,
                bodyHandler: function () {
                    return viewModel.title + ", " + viewModel.startDate.dateString + " - " + viewModel.endDate.dateString + ". " + viewModel.workingDaysFromNow() + " working days remaining";
                }
            });
        }
    };
})();