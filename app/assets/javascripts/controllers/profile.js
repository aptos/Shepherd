angular.module('shepherd.profile',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('profile', {
      url: '/users/:id',
      views: {
        '': {
          templateUrl: 'users/profile.html',
          controller: 'UserCtrl'
        },
        'notes@profile': {
          templateUrl: 'users/notes.html',
          controller: 'NotesCtrl'
        },
        'activity@profile': {
          templateUrl: 'users/activity.html',
          controller: 'ActivityCtrl'
        }
      }
    });
  }])
.controller('UserCtrl',['$scope','$stateParams','Restangular','logger', function ($scope, $stateParams, Restangular, logger) {
  var id = $stateParams.id;

  $scope.segments = ['Onboard','Qualify','Educate','Close','Nurture'];

  Restangular.one('api/users',id).get()
  .then( function(user) {
    $scope.user = user;
    getLocation(user);
  });

  Restangular.one('api/leads',id).get()
  .then( function(lead) {
    if (!!lead.uid) {
      $scope.lead = lead;
    } else {
      $scope.lead = { uid: id};
    }
  });

  $scope.updateLead = function () {
    $scope.update_fail = false;
    Restangular.one('api/leads').post(id, $scope.lead).then( function (lead) {
      $scope.lead = lead;
      logger.logSuccess('Note Updated!');
    }, function () {
      $scope.update_fail = true;
    });
  };

  var getLocation = function(user) {
    if (!user) return;
    if (!!user.latLong) {
      $scope.latLong = user.latLong;
      $scope.address = user.contact.address;
    } else if(!!user.current_location) {
      $scope.latLong = user.current_location.latLong;
      $scope.address = user.current_location.address;
    } else if(!!user.info && !!user.info.location) {
      $scope.address = user.info.location;
    }
    if ($scope.latLong) {
      $scope.markers = [{
        latLng:  $scope.latLong,
        name: user.name,
        style: { fill: '#428bca'}
      }];
    }
  };

  // Initialize map
  var marker_data;
  // marker_data = [{ "latLng": [40.71, -74.00], "name": "New York" }];
  $scope.worldMap = {
    markers: marker_data,
    markerStyle: {
      initial: {
        fill: '#428bca',
        stroke: '#274D00',
        "fill-opacity": 1,
        "stroke-width": 2,
        "stroke-opacity": 0.5
      },
      hover: {
        stroke: 'black',
        "stroke-width": 2
      }
    }
  };

}]);