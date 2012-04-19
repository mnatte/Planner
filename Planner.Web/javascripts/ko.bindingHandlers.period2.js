ko.bindingHandlers.period2 = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
        $(element).slider({
            range: true,
            min: 0,
            max: 120,
            disabled: true,
            values: [viewModel.startDaysFromNow(), viewModel.remainingDays()]/*[75, 300],
            slide: function (event, ui) {
                $("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
            }*/
        });
    },

    update: function (element, valueAccessor, allBindingsAccessor, viewModel) {
        $(element).slider({
            range: true,
            min: 0,
            max: 120,
            disabled: true,
            values: [viewModel.startDaysFromNow(), viewModel.remainingDays()]/*[75, 300],
            slide: function (event, ui) {
                $("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
            }*/
        });
    }
}
/*$('#phases ul li div').progressbar({
value: 37
});*/