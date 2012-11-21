// depends on timeline-min.js
(function () {
    ko.bindingHandlers.assignmentsTimeline = {
        init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
            var resource, obj, ass, abs, _i, _j, _k, _len, _len2, obj2;
            var periods = [];
            var grp = 0;
            var sameRelease = 1;
            var release = '';
            var releases = [];

            // valueAccessor is model passed to binding, viewModel is complete viewModel within scope
            console.log("viewModel: " + ko.toJSON(viewModel));
            console.log("valueAccessor: " + valueAccessor());
            resource = valueAccessor();
            //console.log(resource.assignments);

            for (_i = 0, _len = resource.assignments.length; _i < _len; _i++) {
                ass = resource.assignments[_i];
                //console.log(ass)
                //console.log(ass.period.title + ': ' + ass.period.endDate.dateString);
                if (releases.indexOf(ass.release) === -1) {
                    grp++;
                    releases.push(ass.release);
                    release = ass.release;
                    sameRelease = 1;
                } else {
                    release = ass.release + '[' + sameRelease + ']'
                    sameRelease++;
                }
                console.log(release);

                obj = {
                    group: release,
                    start: ass.period.startDate.date,
                    end: ass.period.endDate.date,
                    content: ass.period.title,
                    info: ass.period.toString()
                };
                if (ass.period.startDate.dateString === ass.period.endDate.dateString) {
                    delete obj.end;
                }
                periods.push(obj);
            }

            for (_j = 0, _len2 = resource.periodsAway.length; _j < _len2; _j++) {
                abs = resource.periodsAway[_j];
                //console.log(abs)
                //console.log(abs.title + ': ' + abs.endDate.dateString);

                obj2 = {
                    group: 'Away',
                    start: abs.startDate.date,
                    end: abs.endDate.date,
                    content: abs.title,
                    info: abs.toString()
                };
                if (abs.startDate.dateString === abs.endDate.dateString) {
                    delete obj2.end;
                }

                periods.push(obj2);
            }
            //console.log(periods);
            //console.log(element);

            // Instantiate our timeline object.
            timeline = new links.Timeline(element);

            var options = {
                "width": "100%",
                // distinct releases + Away
                "height": ((grp + 1) * 100) + "px",
                "style": "box",
                "eventMargin": 5, // minimal margin between events 
                "intervalMin": 1000 * 60 * 60 * 24,          // one day in milliseconds
                "intervalMax": 1000 * 60 * 60 * 24 * 31 * 3  // about three months in milliseconds
            };

            function onSelectedChanged(properties) {
                $(element).find('#details').html('');
                var sel = timeline.getSelection();
                if (sel.length) {
                    if (sel[0] != undefined) {
                        var item = periods[sel[0].row];
                        //$.each(item, function (name, value) {
                        //document.getElementById('details').innerHTML += (name + ": " + value) + " selected";
                        //});
                        if (typeof item.info !== "undefined")
                            $(element).find('#details').html(item.info);
                    }
                }
            }

            // attach an event listener using the links events handler
            links.events.addListener(timeline, 'select', onSelectedChanged);


            // Draw our timeline with the created data and options 
            timeline.draw(periods, options);
            $(element).append('<div id="details">');
        }
    };
})();