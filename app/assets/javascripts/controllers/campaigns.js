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
    Restangular.one('campaigns').get()
    .then( function(campaigns) {
      $scope.campaigns = campaigns;
      summarize($scope.campaigns);
    });
  };
  $scope.refresh();

  $scope.totals = {
    utm_source: 0,
    utm_medium: 0,
    utm_content: 0
  };

  var summarize = function (campaigns) {
    console.info("campaigns", campaigns)
    _.forEach(campaigns, function (campaign) {

      _.forEach($scope.totals, function (value, key) {
        console.info("v,k", value, key, campaign[key])
        var total = _.reduce(campaign[key], function (sum, num) {return sum + num; } );
        $scope.totals[key] = total;
      });

    });
  };

}]);