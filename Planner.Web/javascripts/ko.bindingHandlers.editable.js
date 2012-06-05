(function () {
    ko.bindingHandlers.editable = {
        init: function (element, valueAccessor, allBindingsAccessor, dataContext) {
            ko.utils.registerEventHandler(element, "blur", function () {
                var modelValue = valueAccessor();
                var elementValue = element.innerHTML;
                if (ko.isWriteableObservable(modelValue)) {
                    modelValue(elementValue);
                }
                else { //handle non-observable one-way binding
                    var allBindings = allBindingsAccessor();
                    if (allBindings['_ko_property_writers'] && allBindings['_ko_property_writers'].editable) {
                        allBindings['_ko_property_writers'].editable(elementValue);
                    }
                    //console.log(dataContext);
                }
            })
        },
        update: function (element, valueAccessor) {
            var value = ko.utils.unwrapObservable(valueAccessor()) || "";
            element.innerHTML = value;
        }
    };
    //    // depends on jquery.editinplace.js
    //    ko.bindingHandlers.editable = {
    //        init: function (element, valueAccessor, allBindingsAccessor, data) {
    //            console.log('init editable');
    //            $(element).editInPlace({
    //                /*url: "capture.php",  you no longer need this since you are using the callback option*/
    //                /*params:"call.php", this is an odd looking params string. It typically would be in the format key=val&key2=val2 */
    //                callback: function (original_element, html, original) {
    //                    //assuming you are sending a post request:
    //                    //here call.php is the original params setting you had
    //                    //$.post('capture.php', 'call.php', function (data, textStatus, XMLHttpRequest) {
    //                    console.log("html: " + html);
    //                    console.log("original_element: " + original_element);
    //                    console.log("original: " + original);
    //                    //data = data.split('&');
    //                    //alert('after splitting: ' + data[2]);
    //                    //not sure exactly which element you want to change, but it should give you the idea
    //                    //$(original_element).text(data[2]);
    //                    //});
    //                }
    //            });
    //        },

    //        update: function (element, valueAccessor) {
    //            console.log('update editable');
    //            $(element).editInPlace({
    //                /*url: "capture.php",  you no longer need this since you are using the callback option*/
    //                /*params:"call.php", this is an odd looking params string. It typically would be in the format key=val&key2=val2 */
    //                callback: function (original_element, html, original) {
    //                    //assuming you are sending a post request:
    //                    //here call.php is the original params setting you had
    //                    //$.post('capture.php', 'call.php', function (data, textStatus, XMLHttpRequest) {
    //                    console.log("html: " + html);
    //                    console.log("original_element: " + original_element);
    //                    console.log("original: " + original);
    //                    //data = data.split('&');
    //                    //alert('after splitting: ' + data[2]);
    //                    //not sure exactly which element you want to change, but it should give you the idea
    //                    //$(original_element).text(data[2]);
    //                    //});
    //                }
    //            });
    //        }
    //    }; // closing of whole binding
})();                                 // closing of wrapping function
