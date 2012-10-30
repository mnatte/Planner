(function () {
    ko.bindingHandlers.multipleSelect = {
        store: function (element, viewModel) {
            var result = [];
            var nodes = this.childNodes;
            for (var i = 0, j = nodes.length; i < j; i++) {
                var node = nodes[i];
                if ((node.tagName == "OPTION") && node.selected)
                    result.push(ko.selectExtensions.readValue(node));
            }
            console.log(result);
            console.log(viewModel);
            viewModel.projects = ko.observableArray(result);
            valueAccessor(result);

        },
        init: function (element, valueAccessor, allBindingsAccessor, data) {
            ko.utils.registerEventHandler(element, "change", function (event) {
                var options = valueAccessor();
                //truncate options
                options.splice(0);
                // 'this' is the UI element we bind to
                var result = [];
                var nodes = this.childNodes;
                for (var i = 0, j = nodes.length; i < j; i++) {
                    var node = nodes[i];
                    if ((node.tagName == "OPTION") && node.selected)
                        options.push(ko.selectExtensions.readValue(node));
                }
                console.log("data: " + data);
                console.log("options isObservable: " + ko.isObservable(options));
                //data = options;
                //options.push(result);
                console.log("options: " + ko.toJSON(options));
            });
        },

        update: function (element, valueAccessor) {
            console.log("UPDATE in multipleSelect binding!")
            if (element.tagName != "SELECT")
                throw new Error("values binding applies only to SELECT elements");
            // valueAccessor() result is the observable passed to the binding
            var newValue = ko.utils.unwrapObservable(valueAccessor());
            console.log("update in multipleSelect binding. newValue:" + ko.toJSON(newValue))
            if (newValue && typeof newValue.length == "number") {
                var nodes = element.childNodes;
                for (var i = 0, j = nodes.length; i < j; i++) {
                    var node = nodes[i];
                    console.log(ko.selectExtensions.readValue(node));
                    if (node.tagName == "OPTION") {
                        // IE6 sometimes throws "unknown error" if you try to write to .selected directly, whereas Firefox struggles with setAttribute. Pick one based on browser.
                        if (navigator.userAgent.indexOf("MSIE 6") >= 0)
                            node.setAttribute("selected", ko.utils.arrayIndexOf(newValue, ko.selectExtensions.readValue(node)) >= 0);
                        else
                        //console.log(ko.utils.arrayIndexOf(newValue, ko.selectExtensions.readValue(node)) >= 0);
                        //node.selected = ko.utils.arrayIndexOf(newValue, ko.selectExtensions.readValue(node)) >= 0;
                            node.selected = ko.utils.arrayIndexOf(newValue, ko.selectExtensions.readValue(node)) >= 0;
                        //ko.utils.setOptionNodeSelectionState(node, ko.utils.arrayIndexOf(newValue, ko.selectExtensions.readValue(node)) >= 0);
                    }
                }
            }
        }
    }; // closing of whole binding
})();                           // closing of wrapping function
