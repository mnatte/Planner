(function() {
  var root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  root.Mnd || (root.Mnd = {});

  Mnd.Timeline = (function() {

    function Timeline(data, observableSelected, width, height, divName, detailsDiv) {
      this.data = data;
      this.observableSelected = observableSelected;
      this.width = width != null ? width : "100%";
      this.height = height != null ? height : "800px";
      this.divName = divName != null ? divName : "mytimeline";
      this.detailsDiv = detailsDiv != null ? detailsDiv : "details";
      this.onSelectedChanged = __bind(this.onSelectedChanged, this);
      this.options = {
        "width": this.width,
        "height": this.height,
        "style": "box",
        "eventMargin": 5,
        "intervalMin": 1000 * 60 * 60 * 24,
        "intervalMax": 1000 * 60 * 60 * 24 * 31 * 3,
        "editable": false
      };
      this.timeline = new links.Timeline(document.getElementById(this.divName));
      links.events.addListener(this.timeline, 'select', this.onSelectedChanged);
      this.details = document.getElementById(this.detailsDiv);
    }

    Timeline.prototype.draw = function() {
      return this.timeline.draw(this.data, this.options);
    };

    Timeline.prototype.clearDetails = function() {
      return $(this.details).html('');
    };

    Timeline.prototype.onSelectedChanged = function(properties) {
      var item, sel;
      $(this.details).html('');
      sel = this.timeline.getSelection();
      if (sel.length) {
        if (sel[0] !== void 0) {
          item = this.data[sel[0].row];
          if (typeof item.info !== "undefined") $(this.details).html(item.info);
          if (typeof this.observableSelected !== "undefined") {
            return this.observableSelected(item);
          }
        }
      }
    };

    return Timeline;

  })();

  root.Mnd.Timeline = Mnd.Timeline;

}).call(this);
