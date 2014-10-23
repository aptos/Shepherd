var directives = angular.module('Directives');

directives.directive('uiJvectormap', function () {
  return {
    restrict: 'A',
    scope: {
      options: '='
    },
    link: function(scope, ele, attrs) {
      var options;
      options = scope.options;

      var config = {
        map: 'world_mill_en',
        markers: [],
        normalizeFunction: 'polynomial',
        backgroundColor: null,
        zoomOnScroll: false,
        regionStyle: {
          initial: {
            fill: '#EEEFF3'
          },
          hover: {
            fill: '#DDDDDD'
          }
        },
        markerStyle: {
          initial: {
            fill: '#BF616A',
            stroke: 'rgba(191,97,106,.8)',
            "fill-opacity": 1,
            "stroke-width": 9,
            "stroke-opacity": 0.5
          },
          hover: {
            stroke: 'black',
            "stroke-width": 2
          }
        }
      };

      angular.extend(config, options);

      return ele.vectorMap(config);
    }
  };
});