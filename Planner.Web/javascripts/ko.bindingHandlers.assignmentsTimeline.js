﻿// depends on timeline-min.js
(function () {
    ko.bindingHandlers.assignmentsTimeline = {
        init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
            console.log("viewModel: " + ko.toJSON(viewModel));
            var resource, obj, ass, abs, _i, _j, _k, _len, _len2, obj2, observableModel;
            var periods = [];
            var grp = 0;
            var sameRelease = 1;
            var key = '';
            var release = '';
            var releases = [];
            var trackAssignments = [];

            // valueAccessor is model passed to binding, viewModel is complete viewModel within scope

            console.log("valueAccessor: " + valueAccessor());
            resource = valueAccessor();
            observableModel = allBindingsAccessor().observableModel;
            //console.log(resource.assignments);

            for (_i = 0, _len = resource.assignments.length; _i < _len; _i++) {
                ass = resource.assignments[_i];
                //console.log(ass)
                //console.log(ass.period.title + ': ' + ass.period.endDate.dateString);
                //key = ass.release.title + ass.project.title + ass.activity.title + ass.deliverable.title;
                ///console.log(key);

                release = createRowItem(ass.release.title, 0);
                //if (releases.indexOf(key) === -1) {
                //grp++;
                //releases.push(key);
                //release = ass.release.title;
                //sameRelease++;
                // } else {
                // release = ass.release.title + '[' + sameRelease + ']'
                //sameRelease++;
                //}
                console.log(release);

                obj = {
                    group: release,
                    start: ass.period.startDate.date,
                    end: ass.period.endDate.date,
                    content: ass.period.title,
                    info: ass.period.toString(),
                    resource: resource,
                    assignment: ass
                };
                if (ass.period.startDate.dateString === ass.period.endDate.dateString) {
                    delete obj.end;
                }
                periods.push(obj);
            }

            for (_j = 0, _len2 = resource.periodsAway.length; _j < _len2; _j++) {
                abs = resource.periodsAway[_j];
                abs.person = resource;
                //console.log(abs)
                //console.log(abs.title + ': ' + abs.endDate.dateString);

                obj2 = {
                    group: 'Away',
                    start: abs.startDate.date,
                    end: abs.endDate.date,
                    content: abs.title,
                    info: abs.toString(),
                    resource: resource,
                    absence: abs
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
                "height": ((trackAssignments.length + 1) * 100) + "px",
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
                        if (typeof observableModel !== "undefined")
                            observableModel(item);
                    }
                }
            }

            function createRowItem(item, index) {
                var identifier;
                identifier = item + index;
                if (trackAssignments.indexOf(identifier) === -1) {
                    trackAssignments.push(identifier);
                    return item + '[' + index + ']';
                } else {
                    index++;
                    return createRowItem(item, index);
                }
            };

            // attach an event listener using the links events handler
            links.events.addListener(timeline, 'select', onSelectedChanged);


            // Draw our timeline with the created data and options 
            timeline.draw(periods, options);
            $(element).append('<div id="details">');
        }
    };
})();