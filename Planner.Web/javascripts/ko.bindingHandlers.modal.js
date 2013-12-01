// depends on jquery.modal.min.js
ko.bindingHandlers.modal = {
    init: function (element, valueAccessor, allBindings, vm, context) {
        var modal = valueAccessor();
        //init the modal and make sure that we clear the observable no matter how the modal is closed
        $(element).modal().on("hidden", function () {
            if (ko.isWriteableObservable(modal)) {
                modal(null);
            }
        });

        //template's name field can accept a function to return the name dynamically
        var templateName = function () {
            var value = modal();
            return value && value.name;
        };

        //a computed to wrap the current modal data
        var templateData = ko.computed(function () {
            var value = modal();
            return value && value.data;
        });

        //apply the template binding to this element
        return ko.applyBindingsToNode(element, { template: { 'if': modal, name: templateName, data: templateData} }, context);
    },
    update: function (element, valueAccessor) {
        var data = ko.utils.unwrapObservable(valueAccessor());
        //show or hide the modal depending on whether the associated data is populated
        $(element).modal(data ? "show" : "hide");
    }
};