angular.module('shepherd.users',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('users', {
      url: '/users/?db',
      views: {
        '': {
          templateUrl: 'users/index.html',
          controller: 'UsersCtrl'
        }
      }
    });
  }])
.controller('UsersCtrl',['$scope','$stateParams','Restangular','logger', function ($scope, $stateParams, Restangular, logger) {
  $scope.db = $stateParams.db;

  var refresh = function () {
    Restangular.all('users').getList({db: $scope.db})
    .then( function(users) {
      $scope.users = users;
    });
  };
  refresh();

  $scope.dateformat = 'timeago';

  $scope.sort = {
    column: 'updated_at',
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