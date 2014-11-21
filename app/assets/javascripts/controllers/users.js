angular.module('shepherd.users',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('users', {
      url: '/users',
      views: {
        '': {
          templateUrl: 'users/index.html',
          controller: 'UsersCtrl'
        }
      }
    });
  }])
.controller('UsersCtrl',['$scope','Restangular', function ($scope, Restangular) {
  Restangular.all('users').getList()
  .then( function(users) {
    $scope.users = users;
  });

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

  $scope.addLead = function () {
    console.info("Add Lead", $scope.new_lead)
  };

}]);