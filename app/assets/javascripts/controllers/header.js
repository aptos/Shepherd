angular.module('shepherd.header', [])
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}])
.controller('SiteCtrl',['$scope','$rootScope', 'Restangular', function ($scope, $rootScope, Restangular) {
  Restangular.one('me').get().then( function (me) { $rootScope.me = me; });
}])
.controller('NavCtrl', [ '$scope','$rootScope','$state','Restangular', 'Storage','$filter', function($scope, $rootScope, $state, Restangular, Storage, $filter) {
  $scope.navbarCollapsed = true;

  var refresh = function () {
    Restangular.all('notes' ).getList().then( function(notes) {
      $scope.reminders = notes;
    });
  };
  refresh();

  $scope.getUsers = function (val) {
    var names = Storage.fetch('users');
    if (!!names) {
      return $filter('limitTo')($filter('filter')(names, val), 8);
    } else {
      return Restangular.all('users/summary').getList()
      .then( function(users) {
        if (!!users) Storage.set('users', users, 60);
        var names = users;
        return $filter('limitTo')($filter('filter')(names, val), 8);
      });
    }
  };

  $scope.openProfile = function () {
    if (!$scope.search_user) return;
    $state.go('profile', { id: $scope.search_user.id });
  };

  return $scope.$on('taskRemaining:changed', function(event) {
    refresh();
  });
}]);