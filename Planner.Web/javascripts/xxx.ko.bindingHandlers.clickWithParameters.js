ko.bindingHandlers.clickWithParameters = {
    init: function (element, valueAccessor, allBindingsAccessor, context) {
        var options = valueAccessor();
        console.log options;
        var newValueAccessor = function () {
            return function () {
                options.action.apply(context, options.parameters);
            };
        };
        ko.bindingHandlers.click.init(element, newValueAccessor, allBindingsAccessor, context);
    }
};

