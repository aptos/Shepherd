angular.module('shepherd.messages',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('messages', {
      url: '/messages',
      views: {
        '': {
          templateUrl: 'messages/summary.html',
          controller: 'MessagesCtrl'
        },
        'templates@messages': {
          templateUrl: 'messages/templates.html'
        },
      }
    });
  }])
.controller('MessagesCtrl',['$scope','Restangular','logger', function ($scope, Restangular, logger) {

  $scope.refresh = function () {
    $scope.refreshing = true;
    Restangular.one('messages').get()
    .then( function(messages) {
      $scope.messages = messages;
      $scope.refreshing = false;
    }, function () { $scope.refreshing = false; });
  };
  $scope.refresh();

  $scope.show_message = false;
  $scope.view = function (name) {
    Restangular.one('messages/template').get({name: name})
    .then( function(template) {
      $scope.template = template;
      $scope.show_message = true;
    });
  };

  $scope.close = function () {
    $scope.show_message = false;
  };

  $scope.update = function () {
    Restangular.one('messages').post('template',$scope.template)
    .then( function(template) {
      logger.logSuccess("Template Updated!");
      $scope.show_message = false;
    }, function () {
      logger.logError("Bummer, something went wrong...");
    });
  };

  $scope.head = [
  {head: "Template", column: "template"},
  {head: "Subject", column: "subject"},
  {head: "Sent", column: "sent"},
  {head: "Opens", column: "opened"},
  {head: "Clicks", column: "clicked"},
  {head: "Updated", column: "updated"}
  ];

  $scope.sort = {
    column: 'updated',
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