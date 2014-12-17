angular.module('shepherd.campaigns',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('campaigns', {
      url: '/campaigns',
      views: {
        '': {
          templateUrl: 'campaigns/summary.html',
          controller: 'campaignsCtrl'
        }
      }
    });
  }])
.controller('campaignsCtrl',['$scope','Restangular', function ($scope, Restangular) {

  $scope.refresh = function () {
    Restangular.one('campaigns','TaskIT').get()
    .then( function(timeline) {
      $scope.timeline = timeline;
    });
  };
  $scope.refresh();


  lineChart1 = {};
  lineChart1.data1 = [[1, 15], [2, 20], [3, 14], [4, 10], [5, 10], [6, 20], [7, 28], [8, 26], [9, 22]];
  $scope.line1 = {};
  $scope.line1.data = [
  {
    data: lineChart1.data1,
    label: 'Trend'
  }
  ];
  $scope.line1.options = {
    series: {
      lines: {
        show: true,
        fill: true,
        fillColor: {
          colors: [
          {
            opacity: 0
          }, {
            opacity: 0.3
          }
          ]
        }
      },
      points: {
        show: true,
        lineWidth: 2,
        fill: true,
        fillColor: "#ffffff",
        symbol: "circle",
        radius: 5
      }
    },
    colors: [$scope.color.primary, $scope.color.infoAlt],
    tooltip: true,
    tooltipOpts: {
      defaultTheme: false
    },
    grid: {
      hoverable: true,
      clickable: true,
      tickColor: "#f9f9f9",
      borderWidth: 1,
      borderColor: "#eeeeee"
    },
    xaxis: {
      ticks: [[1, 'Jan.'], [2, 'Feb.'], [3, 'Mar.'], [4, 'Apr.'], [5, 'May'], [6, 'June'], [7, 'July'], [8, 'Aug.'], [9, 'Sept.'], [10, 'Oct.'], [11, 'Nov.'], [12, 'Dec.']]
    }
  };


}]);