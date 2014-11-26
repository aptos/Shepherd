angular.module('shepherd.header', [])
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}])
.controller('SiteCtrl',['$scope','$rootScope', '$cookies', 'Restangular', '$window','$state', function ($scope, $rootScope, $cookies, Restangular, $window, $state) {
  Restangular.one('me').get().then( function (me) { $rootScope.me = me; });

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
    Restangular.all('users').getList()
    .then( function(users) {
      if (!!users) Storage.set('users', users);
    });
  });


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
    console.info("GetUsers")
    if (!!Storage.get('usernames')) {
      console.info("from Storage")
      var names =  _.pluck(Storage.get('users'), 'name');
      return $filter('limitTo')($filter('filter')(names, val), 8);
    } else {
      console.info("from request")
      return Restangular.all('users').getList()
      .then( function(users) {
        if (!!users) Storage.set('users', users);
        var names =  _.pluck(Storage.get('users'), 'name');
        return $filter('limitTo')($filter('filter')(names, val), 8);
      });
    }
  };

  $scope.openProfile = function () {
    var users = _.where(Storage.get('users'), {'name' : $scope.query});
    if (angular.isDefined(users[0])) $state.go('profile', {id: users[0].id});
  };

  // $scope.$watch('query', function () {
  //   console.info("search", $scope.query)
  //   if (Storage.get('usernames').length) {
  //     var user = _.where(Storage.get('users'), {'name' : $scope.query});
  //     console.info("Found", user)
  //     if (angular.isDefined(user)) $state.go('profile', {id: user.id});
  //   }
  // });

return $scope.$on('taskRemaining:changed', function(event) {
  refresh();
});
}]);