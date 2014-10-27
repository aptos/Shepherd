//= require_tree ./controllers
//= require_tree ./directives
//= require_self

var app = angular.module('shepherd', [
  'ngAnimate',
  'ngCookies',
  'ui.router',
  'templates',
  'restangular',
  'ui.bootstrap',
  'shepherd.dashboard',
  'shepherd.maps',
  'shepherd.users',
  'shepherd.profile'
  ])
.run(['$rootScope', '$state', '$stateParams',
  function ($rootScope, $state, $stateParams) {
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;
  }])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
    .state('signout', {
      url: '/signout',
      templateUrl: 'signin.html',
      controller: 'AdiosCtrl'
    });

    // default fallback route
    $urlRouterProvider.otherwise('/');

    // enable HTML5 mode for SEO
    $locationProvider.html5Mode(true);

  }])
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}])
.controller('SiteCtrl',['$scope', '$cookies', 'Restangular', '$window','$state', function ($scope, $cookies, Restangular, $window, $state) {
  $scope.site = $cookies.site;
  $scope.siteNames = {
    'taskit-pro': 'Juniper',
    'taskit': 'TaskIT'
  };
  $scope.setSite = function (site) {
    console.info("Set Site ",site)
    Restangular.one('api/site').get({site: site}).then( function (resp) {
      $scope.site = resp.site;
    }, function () { console.error(resp)});
    $state.go('dashboard');
    $window.location.reload();
  };
  console.info("Site: ", $scope.siteNames[$scope.site])
}])
.filter('moment', function() {
  return function(dateString, format, eob) {
    if (!dateString) { return "-"; }
    if (format) {
      if (format == "timeago") {
        if (eob == 'true') {
          return moment(dateString).add('days',1).fromNow();
        } else {
          return moment(dateString).fromNow();
        }
      } else {
        return moment(dateString).format(format);
      }
    } else {
      return moment(dateString).format("YYYY-MM-DD");
    }
  };
});