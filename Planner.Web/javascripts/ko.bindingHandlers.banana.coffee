# depends on jquery.modal.min.js
ko.bindingHandlers.empty = {
	# element is DOM-element bound to
	# valueAccessor is function to get model property that is bound to
	# allBindings is object to access all model values bound to the element e.g. allBindings.get('secondBoundProperty') to get value of secondBoundProperty
		# use in HTML as <div data-bind="myBinding: property1, secondBoundProperty: 100">
	# vm is entire viewmodel; deprecated in ko 3.0 -> use bindingContext.$data instead or bindingContext.$rawData to access viewmodel
	# context is an object holding the binding context available to this element's bindings.
    init: (element, valueAccessor, allBindings, vm, context) ->
    update: (element, valueAccessor) ->
};