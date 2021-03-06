angular.module('shepherd.profile',['restangular','ui.bootstrap'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('profile', {
      url: '/users/:id?db',
      views: {
        '': {
          templateUrl: 'users/profile.html',
          controller: 'UserCtrl'
        },
        'notes@profile': {
          templateUrl: 'users/notes.html',
          controller: 'NotesCtrl'
        },
        'gmail@profile': {
          templateUrl: 'users/gmail.html',
          controller: 'GmailCtrl'
        },
        'gmail.list@profile': {
          templateUrl: 'users/gmail.list.html'
        },
        'gmail.message@profile': {
          templateUrl: 'users/gmail.message.html'
        },
        'gmail.compose@profile': {
          templateUrl: 'users/gmail.compose.html'
        },
        'activity@profile': {
          templateUrl: 'users/activity.html',
          controller: 'ActivityCtrl'
        }
      }
    });
  }])
.controller('UserCtrl',['$scope','$rootScope','$stateParams','Restangular','logger', function ($scope, $rootScope, $stateParams, Restangular, logger) {
  var id = $stateParams.id;
  var db = $stateParams.db;

  $scope.segments = ['Sales Followup','Provider Onboard','Onboard','Qualify','Educate','Close','Nurture'];

  Restangular.one('users',id).get({db: db})
  .then( function(user) {
    $scope.user = user;
    getLocation(user);
  });

  Restangular.one('leads',id).get()
  .then( function(lead) {
    if (!!lead && !!lead.uid) {
      $scope.lead = lead;
    } else {
      $scope.lead = { uid: id};
    }
    if (!$scope.lead.info) $scope.lead.info = { phone: null };
    if ($scope.lead.info.phone) $scope.phone = $scope.lead.info.phone;
    if ($scope.lead.info.company) $scope.company = $scope.lead.info.company;
    if ($scope.lead.info.title) $scope.title = $scope.lead.info.title;
  });

  $scope.updateLead = function (msg) {
    var msg = msg || 'Note Updated!'
    $scope.update_fail = false;
    Restangular.one('leads').post(id, $scope.lead).then( function (lead) {
      $scope.lead = lead;
      logger.logSuccess(msg);
    }, function () {
      $scope.update_fail = true;
    });
  };

  $scope.edit_phone = false;
  $scope.$watch('edit_phone', function () {
    if (!!$scope.edit_phone) return;
    if ($scope.phone && $scope.phone != $scope.lead.info.phone) {
      console.info("Phone updated!", $scope.phone);
      $scope.lead.info.phone = $scope.phone;
      $scope.updateLead('Phone number updated!');
    }
  });

  $scope.edit_company = false;
  $scope.$watch('edit_company', function () {
    if (!!$scope.edit_company) return;
    if ($scope.company && $scope.company != $scope.lead.info.company) {
      console.info("Company updated!", $scope.company);
      $scope.lead.info.company = $scope.company;
      $scope.updateLead('Company updated!');
    }
  });

  $scope.edit_title = false;
  $scope.$watch('edit_title', function () {
    if (!!$scope.edit_title) return;
    if ($scope.title && $scope.title != $scope.lead.info.title) {
      console.info("Title updated!", $scope.title);
      $scope.lead.info.title = $scope.title;
      $scope.updateLead('Title updated!');
    }
  });

  $scope.cancel = function () {
    $scope.phone = $scope.lead.info.phone;
    $scope.company = $scope.lead.info.company;
    $scope.title = $scope.lead.info.title;
    $scope.edit_phone = false;
    $scope.edit_company = false;
    $scope.edit_title = false;
  };

  var getLocation = function(user) {
    if (!user) return;
    if (!!user.latLong) {
      $scope.latLong = user.latLong;
      $scope.address = user.address;
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