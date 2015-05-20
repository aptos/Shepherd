angular.module('shepherd.prospects',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('prospects', {
      url: '/prospects',
      views: {
        '': {
          templateUrl: 'prospects/index.html',
          controller: 'ProspectsCtrl'
        }
      }
    });
  }])
.controller('ProspectsCtrl',['$scope','$stateParams','Restangular','logger', function ($scope, $stateParams, Restangular,logger) {
  var db = $stateParams.db;

  var refresh = function () {
    Restangular.all('leads').getList()
    .then( function(prospects) {
      $scope.prospects = prospects;
    });
  };
  refresh();

  $scope.dateformat = 'timeago';

  $scope.sort = {
    column: 'email',
    descending: false
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
    console.info("Add Lead", $scope.new_lead);
    $scope.saving = true;
    Restangular.all('leads').post($scope.new_lead).then( function (lead) {
      logger.logSuccess(lead.info.name + " has been added");
      $scope.new_lead = {};
      refresh();
      $scope.saving = false;
    }, function () { $scope.saving = false; logger.logError("Bummer, something went wrong..."); });
  };

}]);