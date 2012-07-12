(function () {
    ko.bindingHandlers.period = {
        init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).css("width", "85%").css("left", "13%");
        }
    };
})();