ko.bindingHandlers.period = {
    init: function (element, valueAccessor) {
        $(element).progressbar({
            value: valueAccessor()
        });
    },

    update: function (element, valueAccessor) {
        $(element).progressbar({
            value: valueAccessor()
        });
    }
}
/*$('#phases ul li div').progressbar({
    value: 37
});*/