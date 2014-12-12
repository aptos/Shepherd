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
.controller('MessagesCtrl',['$scope','Restangular', function ($scope, Restangular) {

  $scope.refresh = function () {
    $scope.refreshing = true;
    Restangular.one('messages').get()
    .then( function(messages) {
      $scope.messages = messages;
      $scope.refreshing = false;
    }, function () { $scope.refreshing = false });
  };
  $scope.refresh();

  $scope.view = function (name) {
    Restangular.one('messages/template').get({name: name})
    .then( function(template) {
      $scope.template = template;
    });
  }

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