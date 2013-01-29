var timeline;

// Called when the Visualization API is loaded.
function drawTimeline(data, observableSelected, width, height, divName, detailsDiv) {
    //console.log(width);
    var _w, _h, _div, _details;
    if (typeof width !== "undefined") {
        _w = width;
    }
    else {
        _w = "100%";
    }

    if (typeof height !== "undefined") {
        _h = height;
    }
    else {
        _h = "800px";
    }
    if (typeof divName !== "undefined") {
        _div = divName;
    }
    else {
        _div = "mytimeline";
    }
    if (typeof detailsDiv !== "undefined") {
        _details = detailsDiv;
    }
    else {
        _details = "details";
    }

    // specify options
    var options = {
        "width": _w, //"100%",
        "height": _h, //"800px",
        "style": "box",
        "eventMargin": 5, // minimal margin between events 
        "intervalMin": 1000 * 60 * 60 * 24,          // one day in milliseconds
        "intervalMax": 1000 * 60 * 60 * 24 * 31 * 3  // about three months in milliseconds
    };

    // Instantiate our timeline object.
    timeline = new links.Timeline(document.getElementById(_div));
    //console.log('timeline div: ' + timeline);

    function onSelectedChanged(properties) {
        details = document.getElementById(_details);
        $(details).html('');
        var sel = timeline.getSelection();
        console.log('selection:');
        console.log(sel);
        if (sel.length) {
            console.log(sel[0]);
            if (sel[0] != undefined) {
                var item = data[sel[0].row];
                //$.each(item, function (name, value) {
                //document.getElementById('details').innerHTML += (name + ": " + value) + " selected";
                //});
                if (typeof item.info !== "undefined")
                    $(details).html(item.info);
                if (typeof observableSelected !== "undefined")
                    observableSelected(item);
                
            }
        }
    }

    // attach an event listener using the links events handler
    links.events.addListener(timeline, 'select', onSelectedChanged);


    // Draw our timeline with the created data and options 
    timeline.draw(data, options);
}