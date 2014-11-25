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


  $scope.refresh = function () {
    $scope.refreshing = true;
    Restangular.one('campaigns').get()
    .then( function(campaigns) {
      $scope.campaigns = campaigns;
      $scope.refreshing = false;
    }, function () { $scope.refreshing = false });
  };
  $scope.refresh();

  $scope.head = [
  {head: "Template", column: "template"},
  {head: "Subject", column: "subject"},
  {head: "Sent", column: "sent"},
  {head: "Opens", column: "opened"},
  {head: "Clicks", column: "clicked"},
  {head: "Updated", column: "updated"}
  ];

  $scope.sort = {
    column: 'template',
    descending: true
  };

  $scope.selectedCls = function(column) {
    return column == $scope.sort.column && 'sort-' + $scope.sort.descending;
  };

  $scope.changeSorting = function(column) {
    var sort = $scope.sort;
    if (sort.column == column) {
      sort.descending = !sort.descending;
    } else {
      sort.column = column;
      sort.descending = false;
    }
  };
}]);