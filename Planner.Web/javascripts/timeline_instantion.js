var timeline;

// Called when the Visualization API is loaded.
function drawTimeline(data) {

    // specify options
    var options = {
        "width": "100%",
        "height": "800px",
        "style": "box",
        "eventMargin": 5, // minimal margin between events 
        "intervalMin": 1000 * 60 * 60 * 24,          // one day in milliseconds
        "intervalMax": 1000 * 60 * 60 * 24 * 31 * 3  // about three months in milliseconds
    };

    // Instantiate our timeline object.
    timeline = new links.Timeline(document.getElementById('mytimeline'));

    function onSelectedChanged(properties) {
        $('#details').html('');
        var sel = timeline.getSelection();
        if (sel.length) {
            if (sel[0] != undefined) {
                var item = data[sel[0].row];
                //$.each(item, function (name, value) {
                //document.getElementById('details').innerHTML += (name + ": " + value) + " selected";
                //});
                if (typeof item.info !== "undefined")
                    $('#details').html(item.info);
            }
        }
    }

    // attach an event listener using the links events handler
    links.events.addListener(timeline, 'select', onSelectedChanged);


    // Draw our timeline with the created data and options 
    timeline.draw(data, options);
}