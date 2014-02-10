// depends on jquery.modal.min.js
ko.bindingHandlers.modal = {
    /*element is DOM-element bound to
    # valueAccessor is function to get model property that is bound to
    # allBindings is object to access all model values bound to the element e.g. allBindings.get('secondBoundProperty') to get value of secondBoundProperty
        # use in HTML as <div data-bind="myBinding: property1, secondBoundProperty: 100">
    # vm is entire viewmodel; deprecated in ko 3.0 -> use bindingContext.$data instead or bindingContext.$rawData to access viewmodel
    # context is an object holding the binding context available to this element's bindings.
    */
    init: function (element, valueAccessor, allBindings, vm, context) {
        var modelBindingElement = valueAccessor();
        // modelBindingElement is only a function since it is an observable
        // console.log(modelBindingElement);

        //template's name field can accept a function to return the name dynamically
        var templateName = function () {
            // evaluate the observable
            var value = modelBindingElement();
            //console.log("template name");
            //console.log(value);
            //console.log(value && value.name);
            return value && value.name;
        };

        //a computed to wrap the current modal data
        var templateData = ko.computed(function () {
            // evaluate the observable
            var value = modelBindingElement();
            return value && value.data;
        });

        //apply the template binding to this element
        // console.log(modelProperty);
        return ko.applyBindingsToNode(element, { template: { 'if': modelBindingElement, name: templateName, data: templateData} }, context);
    },
    update: function (element, valueAccessor, allBindings, vm, context) {
        var data = ko.utils.unwrapObservable(valueAccessor());
        console.log("update modal");
        console.log(data)
        //console.log(context.$data.closeDialog());
        //show or hide the modal depending on whether the associated data is populated
        if (data) {
            $(element).modal();
        } else {
            $.modal.close();
        }
        /*

        supported modal options and defaults:
        $.modal.defaults = {
        overlay: "#000",        // Overlay color
        opacity: 0.75,          // Overlay opacity
        zIndex: 1,              // Overlay z-index.
        escapeClose: true,      // Allows the user to close the modal by pressing `ESC`
        clickClose: true,       // Allows the user to close the modal by clicking the overlay
        closeText: 'Close',     // Text content for the close <a> tag.
        showClose: true,        // Shows a (X) icon/link in the top-right corner
        modalClass: "modal",    // CSS class added to the element being displayed in the modal.
        spinnerHtml: null,      // HTML appended to the default spinner during AJAX requests.
        showSpinner: true,      // Enable/disable the default spinner during AJAX requests.
        fadeDuration: null,     // Number of milliseconds the fade transition takes (null means no transition)
        fadeDelay: 1.0          // Point during the overlay's fade-in that the modal begins to fade in (.5 = 50%, 1.5 = 150%, etc.)
        };
        */
    }
};