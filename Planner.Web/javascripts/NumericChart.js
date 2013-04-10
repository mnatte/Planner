(function() {
  var root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof global !== "undefined" && global !== null ? global : window;

  root.Mnd || (root.Mnd = {});

  Mnd.NumericChart = (function() {

    function NumericChart(divName, title, subtitle) {
      this.divName = divName;
      this.title = title;
      this.subtitle = subtitle != null ? subtitle : null;
      this.addLineData = __bind(this.addLineData, this);
      this.addLineName = __bind(this.addLineName, this);
      this.options = {
        chart: {
          renderTo: this.divName
        },
        title: {
          text: this.title
        },
        subtitle: {
          text: this.subtitle
        },
        xAxis: {
          labels: {
            align: 'left',
            x: 3,
            y: -3
          }
        },
        yAxis: [
          {
            title: {
              text: null
            },
            labels: {
              align: 'left',
              x: 3,
              y: 16,
              formatter: function() {
                return Highcharts.numberFormat(this.value, 0);
              }
            },
            showFirstLabel: false
          }, {
            linkedTo: 0,
            gridLineWidth: 0,
            opposite: true,
            title: {
              text: null
            },
            labels: {
              align: 'right',
              x: -3,
              y: 16,
              formatter: function() {
                return Highcharts.numberFormat(this.value, 0);
              }
            },
            showFirstLabel: false
          }
        ],
        legend: {
          align: 'left',
          verticalAlign: 'top',
          y: 20,
          floating: true,
          borderWidth: 0
        },
        tooltip: {
          shared: true,
          crosshairs: true
        },
        plotOptions: {
          series: {
            cursor: 'pointer',
            point: {
              events: {
                click: function() {
                  return hs.htmlExpand(null, {
                    pageOrigin: {
                      x: this.pageX,
                      y: this.pageY
                    },
                    headingText: this.series.name,
                    maincontentText: 'day number ' + this.x + ':<br/> ' + this.y + ' hours',
                    width: 200
                  });
                }
              }
            },
            marker: {
              lineWidth: 1
            }
          }
        },
        series: []
      };
    }

    NumericChart.prototype.draw = function() {
      var chart;
      return chart = new Highcharts.Chart(this.options);
    };

    NumericChart.prototype.addLineName = function(linename) {
      return this.options.series.push({
        name: linename
      });
    };

    NumericChart.prototype.addLineData = function(index, data) {
      return this.options.series[index].data = data;
    };

    return NumericChart;

  })();

  root.Mnd.NumericChart = Mnd.NumericChart;

}).call(this);
