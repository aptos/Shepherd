angular.module('shepherd.campaigns',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('campaigns', {
      url: '/campaigns',
      views: {
        '': {
          templateUrl: 'campaigns/summary.html',
          controller: 'CampaignsCtrl'
        },
        'templates@campaigns': {
          templateUrl: 'campaigns/templates.html'
        },
      }
    });
  }])
.controller('CampaignsCtrl',['$scope','Restangular', function ($scope, Restangular) {
  Restangular.one('campaigns').get()
  .then( function(campaigns) {
    $scope.campaigns = campaigns;
  });
}]);