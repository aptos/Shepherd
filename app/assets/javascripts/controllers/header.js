angular.module('shepherd.header', [])
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}])
.controller('SiteCtrl',['$scope','$rootScope', '$cookies', 'Restangular', '$window','$state', function ($scope, $rootScope, $cookies, Restangular, $window, $state) {
  $scope.site = $cookies.site || 'taskitone';
  $scope.siteNames = {
    'taskit-pro': 'Juniper',
    'taskitone': 'TaskIT'
  };
  $scope.setSite = function (site) {
    Restangular.one('site').get({site: site}).then( function (resp) {
      $scope.site = resp.site;
    }, function () { console.error(resp); });
    $state.go('dashboard');
    $window.location.reload();
  };
  return $scope.$on('site:changed', function(event) {
    console.info("Site changed", event)
    $scope.site = $rootScope.site;
  });
}])
.controller('NavCtrl', [ '$scope','$rootScope','$state','Restangular', function($scope, $rootScope, $state, Restangular) {
  $scope.navbarCollapsed = true;

  var refresh = function () {
    Restangular.all('notes' ).getList().then( function(notes) {
      $scope.reminders = notes;
    });
  };
  refresh();

  return $scope.$on('taskRemaining:changed', function(event) {
    refresh();
  });
}]);