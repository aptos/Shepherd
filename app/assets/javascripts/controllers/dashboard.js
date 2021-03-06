angular.module('shepherd.dashboard',['restangular'])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('dashboard', {
      url: '/',
      views: {
        '': {
          templateUrl: 'dashboard/layout.html',
          controller: 'DashboardCtrl'
        },
        'worldMap@dashboard': {
          templateUrl: 'dashboard/user_map.html'
        },
        'taskStats@dashboard': {
          templateUrl: 'dashboard/task_stats.html'
        }
      }
    });
  }])
.controller('DashboardCtrl',['$scope','Restangular', 'Storage', function ($scope, Restangular, Storage) {

  $scope.as_of = "month";
  $scope.db = (Storage.get('db')) ? Storage.get('db'): "taskit2015";

  $scope.refresh = function () {
    Storage.set('db', $scope.db);
    Restangular.all('users').getList({db: $scope.db})
    .then( function(users) {
      $scope.users = users;
      updateUsersMap();
      $scope.total_users = $scope.users.length;
      $scope.new_users = users.reduce(function(u, user) { return (moment(user.created_at).isSame(moment(),$scope.as_of)) ? u + 1 : u; }, 0);
      $scope.visitors = users.reduce(function(u, user) { return (moment(user.updated_at).isSame(moment(),$scope.as_of)) ? u + 1 : u; }, 0);
    });

    Restangular.all('companies/locations').getList({db: $scope.db})
    .then( function(companies) {
      $scope.companies = companies;
      updateCompanyMap();
    });

    Restangular.one('tasks/stats').get({db: $scope.db})
    .then( function(stats) {
      $scope.stats = stats;
    });
  };

  $scope.refresh();

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

  var updateUsersMap = function () {
    var marker_data = [];
    _.each($scope.users, function (user) {
      if (!!user.latLong) {
        marker_data.push({
          latLng: user.latLong,
          name: user.name,
          style: { fill: '#428bca'}
        });
      }
    });
    $scope.markers = marker_data;
  };

  var updateCompanyMap = function () {
    var marker_data = [];
    $scope.locations_count = 0;
    _.each($scope.companies, function (company) {
      if (!!company.locations) {
        $scope.locations_count = $scope.locations_count + company.locations.length;
        _.each(company.locations, function (office) {
          if (!!office.latLng) {
            marker_data.push({
              latLng: office.latLng,
              name: company.name + " - " + office.city,
              style: { fill: '#dff0d8'}
            });
          }
        });
      }
    });
    $scope.markers = marker_data;
  };
}]);
