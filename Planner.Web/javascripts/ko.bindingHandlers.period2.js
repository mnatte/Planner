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
                    return viewModel.title + ", " + viewModel.startDate.dateString + " - " + viewModel.endDate.dateString + ". " + viewModel.workingDaysRemaining() + " working days remaining";
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
                    return viewModel.title + ", " + viewModel.startDate.dateString + " - " + viewModel.endDate.dateString + ". " + viewModel.workingDaysRemaining() + " working days remaining";
                }
            });
        }
    };

    ko.bindingHandlers.fadeVisible = {
        init: function (element, valueAccessor) {
            // Start visible/invisible according to initial value
            var shouldDisplay = valueAccessor();
            $(element).toggle(shouldDisplay);
        },
        update: function (element, valueAccessor, allBindingsAccessor) {
            // On update, fade in/out
            var shouldDisplay = valueAccessor(),
                    allBindings = allBindingsAccessor(),
                    duration = allBindings.fadeDuration || 500; // 500ms is default duration unless otherwise specified

            shouldDisplay ? $(element).fadeIn(duration) : $(element).fadeOut(duration);
        }
    };
})();