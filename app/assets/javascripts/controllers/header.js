angular.module('shepherd.header', [])
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}])
.controller('SiteCtrl',['$scope', '$cookies', 'Restangular', '$window','$state', function ($scope, $cookies, Restangular, $window, $state) {
  $scope.site = $cookies.site || 'taskit';
  $scope.siteNames = {
    'taskit-pro': 'Juniper',
    'taskit': 'TaskIT',
    'taskitone': 'TaskIT'
  };
  $scope.setSite = function (site) {
    Restangular.one('api/site').get({site: site}).then( function (resp) {
      $scope.site = resp.site;
    }, function () { console.error(resp); });
    $state.go('dashboard');
    $window.location.reload();
  };
}])
.controller('NavCtrl', [ '$scope','$rootScope','$state','Restangular', function($scope, $rootScope, $state, Restangular) {
  $scope.navbarCollapsed = true;

  var refresh = function () {
    Restangular.all('api/notes' ).getList().then( function(notes) {
      $scope.reminders = notes;
    });
  };
  refresh();

  return $scope.$on('taskRemaining:changed', function(event) {
    refresh();
  });
}]);